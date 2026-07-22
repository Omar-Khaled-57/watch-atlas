-- Run this in your Supabase SQL editor to create missing recommendation engine tables
-- This migration is safe to run even if some tables already exist

-- Enable UUID generation (safe to run multiple times)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Add recs_enabled column to profiles (safe to run multiple times)
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS recs_enabled BOOLEAN DEFAULT true;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS recs_clear_requested BOOLEAN DEFAULT false;

-- User behavior events (safe to run multiple times)
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'user_events') THEN
    CREATE TABLE user_events (
      id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
      event_type TEXT NOT NULL CHECK (event_type IN (
        'media_view', 'media_view_duration', 'media_save', 'media_unsave',
        'media_favorite', 'media_unfavorite', 'media_complete',
        'rating', 'search', 'genre_browse', 'collection_open',
        'filter_apply', 'recommendation_click', 'recommendation_dismiss',
        'share', 'comment', 'list_add', 'list_remove'
      )),
      media_id BIGINT REFERENCES media(id) ON DELETE SET NULL,
      metadata JSONB DEFAULT '{}'::jsonb,
      device TEXT,
      platform TEXT,
      session_id TEXT,
      created_at TIMESTAMPTZ DEFAULT NOW()
    );
  END IF;
END $$;

-- User recommendation profiles (safe to run multiple times)
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'user_rec_profiles') THEN
    CREATE TABLE user_rec_profiles (
      user_id UUID PRIMARY KEY REFERENCES profiles(id) ON DELETE CASCADE,
      genre_weights JSONB DEFAULT '{}'::jsonb,
      actor_weights JSONB DEFAULT '{}'::jsonb,
      director_weights JSONB DEFAULT '{}'::jsonb,
      keyword_weights JSONB DEFAULT '{}'::jsonb,
      preferred_languages TEXT[] DEFAULT '{}',
      preferred_countries TEXT[] DEFAULT '{}',
      avg_session_duration REAL DEFAULT 0,
      preferred_runtime TEXT DEFAULT 'any' CHECK (preferred_runtime IN ('short', 'medium', 'long', 'any')),
      top_genres TEXT[] DEFAULT '{}',
      top_actors TEXT[] DEFAULT '{}',
      top_directors TEXT[] DEFAULT '{}',
      diversity_seen_count INTEGER DEFAULT 0,
      last_computed_at TIMESTAMPTZ DEFAULT NOW(),
      updated_at TIMESTAMPTZ DEFAULT NOW()
    );
  END IF;
END $$;

-- Media similarity (safe to run multiple times)
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'media_similarity') THEN
    CREATE TABLE media_similarity (
      media_id_a BIGINT NOT NULL REFERENCES media(id) ON DELETE CASCADE,
      media_id_b BIGINT NOT NULL REFERENCES media(id) ON DELETE CASCADE,
      similarity_score REAL NOT NULL DEFAULT 0,
      genre_overlap REAL DEFAULT 0,
      cast_overlap REAL DEFAULT 0,
      keyword_overlap REAL DEFAULT 0,
      theme_overlap REAL DEFAULT 0,
      metadata_overlap REAL DEFAULT 0,
      computed_at TIMESTAMPTZ DEFAULT NOW(),
      PRIMARY KEY (media_id_a, media_id_b),
      CHECK (media_id_a < media_id_b)
    );
  END IF;
END $$;

-- Cached recommendations (safe to run multiple times)
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'recommendations_cache') THEN
    CREATE TABLE recommendations_cache (
      id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
      category TEXT NOT NULL CHECK (category IN (
        'because_you_saved', 'because_you_viewed', 'trending_near_you',
        'popular_this_week', 'continue_exploring', 'new_releases',
        'hidden_gems', 'critically_acclaimed', 'top_rated',
        'similar_to_favorites', 'because_you_like_genre',
        'friends_also_saved', 'users_like_you', 'award_winners',
        'underrated_classics', 'upcoming_releases'
      )),
      media_id BIGINT NOT NULL REFERENCES media(id) ON DELETE CASCADE,
      score REAL NOT NULL DEFAULT 0,
      reason TEXT,
      reason_type TEXT,
      is_dismissed BOOLEAN DEFAULT false,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      expires_at TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '24 hours'),
      UNIQUE(user_id, category, media_id)
    );
  END IF;
END $$;

-- Indexes (safe to run multiple times)
CREATE INDEX IF NOT EXISTS idx_user_events_user ON user_events(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_user_events_type ON user_events(user_id, event_type, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_recs_cache_user ON recommendations_cache(user_id, category, score DESC);
CREATE INDEX IF NOT EXISTS idx_recs_cache_expires ON recommendations_cache(expires_at);

-- RLS policies for new tables (safe to run multiple times)
DO $$
BEGIN
  ALTER TABLE user_events ENABLE ROW LEVEL SECURITY;
EXCEPTION
  WHEN duplicate_object THEN
    -- Policy already exists
END $$;

DO $$
BEGIN
  CREATE POLICY "Users insert own events" ON user_events FOR INSERT TO authenticated WITH CHECK (auth.uid() = user_id);
EXCEPTION
  WHEN duplicate_object THEN
    -- Policy already exists
END $$;

DO $$
BEGIN
  CREATE POLICY "Users view own events" ON user_events FOR SELECT USING (auth.uid() = user_id);
EXCEPTION
  WHEN duplicate_object THEN
    -- Policy already exists
END $$;

DO $$
BEGIN
  CREATE POLICY "Users delete own events" ON user_events FOR DELETE USING (auth.uid() = user_id);
EXCEPTION
  WHEN duplicate_object THEN
    -- Policy already exists
END $$;

DO $$
BEGIN
  ALTER TABLE user_rec_profiles ENABLE ROW LEVEL SECURITY;
EXCEPTION
  WHEN duplicate_object THEN
    -- Policy already exists
END $$;

DO $$
BEGIN
  CREATE POLICY "Users view own rec profile" ON user_rec_profiles FOR SELECT USING (auth.uid() = user_id);
EXCEPTION
  WHEN duplicate_object THEN
    -- Policy already exists
END $$;

DO $$
BEGIN
  CREATE POLICY "System manages rec profiles" ON user_rec_profiles FOR ALL USING (auth.uid() = user_id);
EXCEPTION
  WHEN duplicate_object THEN
    -- Policy already exists
END $$;

DO $$
BEGIN
  ALTER TABLE media_similarity ENABLE ROW LEVEL SECURITY;
EXCEPTION
  WHEN duplicate_object THEN
    -- Policy already exists
END $$;

DO $$
BEGIN
  CREATE POLICY "Similarity is public" ON media_similarity FOR SELECT USING (true);
EXCEPTION
  WHEN duplicate_object THEN
    -- Policy already exists
END $$;

DO $$
BEGIN
  ALTER TABLE recommendations_cache ENABLE ROW LEVEL SECURITY;
EXCEPTION
  WHEN duplicate_object THEN
    -- Policy already exists
END $$;

DO $$
BEGIN
  CREATE POLICY "Users view own recommendations" ON recommendations_cache FOR SELECT USING (auth.uid() = user_id);
EXCEPTION
  WHEN duplicate_object THEN
    -- Policy already exists
END $$;

DO $$
BEGIN
  CREATE POLICY "Users dismiss own recommendations" ON recommendations_cache FOR UPDATE USING (auth.uid() = user_id);
EXCEPTION
  WHEN duplicate_object THEN
    -- Policy already exists
END $$;

-- Grant permissions (safe to run multiple times)
GRANT SELECT, INSERT, UPDATE ON public.recommendations_cache TO authenticated;