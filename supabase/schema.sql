-- WatchAtlas Supabase Schema
-- Run this in your Supabase SQL editor

-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profiles table (extends Supabase auth.users)
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  username TEXT UNIQUE NOT NULL,
  display_name TEXT,
  avatar_url TEXT,
  banner_url TEXT,
  bio TEXT,
  gender TEXT CHECK (gender IN ('male', 'female', 'ratherNotSay')),
  dob DATE,
  default_avatar TEXT,
  role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'moderator', 'admin')),
  is_verified BOOLEAN DEFAULT false,
  followers_count INTEGER DEFAULT 0,
  following_count INTEGER DEFAULT 0,
  lists_count INTEGER DEFAULT 0,
  reviews_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Media table (synced from TMDB/AniList + custom entries)
CREATE TABLE media (
  id BIGINT PRIMARY KEY,
  media_type TEXT NOT NULL,
  title TEXT NOT NULL,
  original_title TEXT,
  native_title TEXT,
  romanized_title TEXT,
  overview TEXT,
  poster_path TEXT,
  backdrop_path TEXT,
  trailer_url TEXT,
  vote_average REAL,
  vote_count INTEGER,
  popularity REAL DEFAULT 0,
  release_date DATE,
  runtime INTEGER,
  genres TEXT[],
  countries TEXT[],
  status TEXT,
  language TEXT,
  adult BOOLEAN DEFAULT false,
  is_custom BOOLEAN DEFAULT false,
  total_episodes INTEGER DEFAULT 0,
  total_seasons INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- External IDs for media (TMDB, AniList, etc.)
CREATE TABLE media_external_ids (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  media_id BIGINT NOT NULL REFERENCES media(id) ON DELETE CASCADE,
  source TEXT NOT NULL,
  external_id TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(source, external_id)
);

-- Custom media (user-created entries)
CREATE TABLE custom_media (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  media_type TEXT NOT NULL,
  description TEXT,
  poster_url TEXT,
  release_year INTEGER,
  country TEXT,
  episode_count INTEGER DEFAULT 0,
  is_private BOOLEAN DEFAULT false,
  is_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- User's media tracking
CREATE TABLE user_media (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  media_id BIGINT NOT NULL REFERENCES media(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  media_type TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('watching', 'completed', 'on_hold', 'dropped', 'plan_to_watch', 'rewatching')),
  season_progress INTEGER DEFAULT 0,
  episode_progress INTEGER DEFAULT 0,
  total_episodes INTEGER DEFAULT 0,
  rewatch_count INTEGER DEFAULT 0,
  user_rating REAL,
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(media_id, user_id)
);

-- Episode/season progress tracking
CREATE TABLE user_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_media_id UUID NOT NULL REFERENCES user_media(id) ON DELETE CASCADE,
  season_number INTEGER DEFAULT 1,
  episode_number INTEGER NOT NULL,
  watched_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_media_id, season_number, episode_number)
);

-- Ratings
CREATE TABLE user_ratings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  media_id BIGINT NOT NULL REFERENCES media(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  rating REAL NOT NULL CHECK (rating >= 0 AND rating <= 10),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(media_id, user_id)
);

-- Reviews
CREATE TABLE user_reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  media_id BIGINT NOT NULL REFERENCES media(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  rating REAL CHECK (rating >= 0 AND rating <= 10),
  likes_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  contains_spoilers BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- User-created lists
CREATE TABLE user_lists (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  list_type TEXT NOT NULL DEFAULT 'public' CHECK (list_type IN ('public', 'private', 'collaborative')),
  is_pinned BOOLEAN DEFAULT false,
  tags TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  item_count INTEGER DEFAULT 0,
  likes_count INTEGER DEFAULT 0
);

-- List items
CREATE TABLE list_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  list_id UUID NOT NULL REFERENCES user_lists(id) ON DELETE CASCADE,
  media_id BIGINT REFERENCES media(id) ON DELETE SET NULL,
  custom_media_id UUID REFERENCES custom_media(id) ON DELETE SET NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  note TEXT,
  added_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(list_id, sort_order)
);

-- Followers
CREATE TABLE followers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  follower_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  following_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(follower_id, following_id),
  CHECK (follower_id != following_id)
);

-- Comments
CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  review_id UUID REFERENCES user_reviews(id) ON DELETE CASCADE,
  media_id BIGINT REFERENCES media(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Notifications
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('new_season', 'new_episode', 'friend_follow', 'list_update', 'review', 'comment', 'recommendation')),
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  image_url TEXT,
  deep_link TEXT,
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Activity log
CREATE TABLE activity_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  action TEXT NOT NULL,
  media_id BIGINT REFERENCES media(id) ON DELETE SET NULL,
  metadata JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Reports (moderation)
CREATE TABLE reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  reporter_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  reported_user_id UUID REFERENCES profiles(id) ON DELETE CASCADE,
  review_id UUID REFERENCES user_reviews(id) ON DELETE SET NULL,
  comment_id UUID REFERENCES comments(id) ON DELETE SET NULL,
  reason TEXT NOT NULL CHECK (reason IN ('spam', 'inappropriate', 'copyright', 'incorrect', 'other')),
  description TEXT,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'resolved', 'dismissed')),
  moderated_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Recommendations
CREATE TABLE recommendations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  media_id BIGINT NOT NULL REFERENCES media(id) ON DELETE CASCADE,
  score REAL NOT NULL DEFAULT 0,
  reason TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Watch history
CREATE TABLE watch_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  media_id BIGINT NOT NULL REFERENCES media(id) ON DELETE CASCADE,
  season_number INTEGER,
  episode_number INTEGER,
  watched_at TIMESTAMPTZ DEFAULT NOW()
);

-- Sync queue (for offline-first)
CREATE TABLE sync_queue (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  table_name TEXT NOT NULL,
  record_id TEXT NOT NULL,
  operation TEXT NOT NULL CHECK (operation IN ('create', 'update', 'delete')),
  data JSONB NOT NULL,
  retry_count INTEGER DEFAULT 0,
  error_message TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_media_type ON media(media_type);
CREATE INDEX idx_media_popularity ON media(popularity DESC);
CREATE INDEX idx_media_release_date ON media(release_date DESC);
CREATE INDEX idx_user_media_user_status ON user_media(user_id, status);
CREATE INDEX idx_user_media_media ON user_media(media_id);
CREATE INDEX idx_user_reviews_media ON user_reviews(media_id);
CREATE INDEX idx_user_lists_user ON user_lists(user_id);
CREATE INDEX idx_followers_follower ON followers(follower_id);
CREATE INDEX idx_followers_following ON followers(following_id);
CREATE INDEX idx_notifications_user ON notifications(user_id, is_read);
CREATE INDEX idx_activity_logs_user ON activity_logs(user_id, created_at DESC);
CREATE INDEX idx_recommendations_user ON recommendations(user_id, score DESC);
CREATE INDEX idx_watch_history_user ON watch_history(user_id, watched_at DESC);
CREATE INDEX idx_media_external_ids_source ON media_external_ids(source, external_id);
CREATE INDEX idx_list_items_list ON list_items(list_id);

-- Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE media ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_lists ENABLE ROW LEVEL SECURITY;
ALTER TABLE list_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE followers ENABLE ROW LEVEL SECURITY;
ALTER TABLE comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE custom_media ENABLE ROW LEVEL SECURITY;
ALTER TABLE recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE watch_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE sync_queue ENABLE ROW LEVEL SECURITY;

-- RLS Policies

-- Profiles: public read, own write, own insert
CREATE POLICY "Profiles are publicly readable" ON profiles FOR SELECT USING (true);
CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE USING (auth.uid() = id);

-- Media: public read
CREATE POLICY "Media is publicly readable" ON media FOR SELECT USING (true);

-- User media: own CRUD
CREATE POLICY "Users manage own media tracking" ON user_media
  FOR ALL USING (auth.uid() = user_id);

-- User progress: own CRUD
CREATE POLICY "Users manage own progress" ON user_progress
  FOR ALL USING (auth.uid() IN (
    SELECT user_id FROM user_media WHERE id = user_media_id
  ));

-- Ratings: own CRUD
CREATE POLICY "Users manage own ratings" ON user_ratings
  FOR ALL USING (auth.uid() = user_id);

-- Reviews: public read, own write
CREATE POLICY "Reviews are publicly readable" ON user_reviews FOR SELECT USING (true);
CREATE POLICY "Users manage own reviews" ON user_reviews
  FOR ALL USING (auth.uid() = user_id);

-- Lists: public read for public lists, own full access
CREATE POLICY "Public lists are readable" ON user_lists
  FOR SELECT USING (list_type = 'public' OR auth.uid() = user_id);
CREATE POLICY "Users manage own lists" ON user_lists
  FOR ALL USING (auth.uid() = user_id);

-- List items: same as parent list
CREATE POLICY "List items readable with list" ON list_items
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM user_lists WHERE id = list_id AND (list_type = 'public' OR user_id = auth.uid()))
  );
CREATE POLICY "Users manage own list items" ON list_items
  FOR ALL USING (
    EXISTS (SELECT 1 FROM user_lists WHERE id = list_id AND user_id = auth.uid())
  );

-- Followers: public read, own manage
CREATE POLICY "Followers are readable" ON followers FOR SELECT USING (true);
CREATE POLICY "Users manage own follows" ON followers
  FOR ALL USING (auth.uid() = follower_id);

-- Comments: public read, own write
CREATE POLICY "Comments are readable" ON comments FOR SELECT USING (true);
CREATE POLICY "Users manage own comments" ON comments
  FOR ALL USING (auth.uid() = user_id);

-- Notifications: own read/update
CREATE POLICY "Users see own notifications" ON notifications
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users update own notifications" ON notifications
  FOR UPDATE USING (auth.uid() = user_id);

-- Activity log: own read
CREATE POLICY "Users see own activity" ON activity_logs
  FOR SELECT USING (auth.uid() = user_id);

-- Reports: insert own, admin read
CREATE POLICY "Users can report" ON reports FOR INSERT WITH CHECK (auth.uid() = reporter_id);
CREATE POLICY "Admins manage reports" ON reports
  FOR ALL USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('moderator', 'admin'))
  );

-- Custom media: public read for non-private, own CRUD
CREATE POLICY "Non-private custom media readable" ON custom_media
  FOR SELECT USING (NOT is_private OR auth.uid() = user_id);
CREATE POLICY "Users manage own custom media" ON custom_media
  FOR ALL USING (auth.uid() = user_id);

-- Sync queue: own
CREATE POLICY "Users manage own sync queue" ON sync_queue
  FOR ALL USING (auth.uid() = user_id);

-- Functions

CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, email, username)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'username', split_part(NEW.email, '@', 1))
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ============================================================
-- Recommendation Engine
-- ============================================================

-- User behavior events (event sourcing for recommendations)
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

CREATE INDEX idx_user_events_user ON user_events(user_id, created_at DESC);
CREATE INDEX idx_user_events_type ON user_events(user_id, event_type, created_at DESC);
CREATE INDEX idx_user_events_media ON user_events(media_id, event_type);
CREATE INDEX idx_user_events_created ON user_events(created_at);

-- User recommendation profiles (aggregated interests, updated periodically)
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

-- Media similarity scores (content-based, periodic batch compute)
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

CREATE INDEX idx_media_similarity_a ON media_similarity(media_id_a, similarity_score DESC);
CREATE INDEX idx_media_similarity_b ON media_similarity(media_id_b, similarity_score DESC);

-- Cached recommendations per user (pre-computed for fast serving)
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

CREATE INDEX idx_recs_cache_user ON recommendations_cache(user_id, category, score DESC);
CREATE INDEX idx_recs_cache_expires ON recommendations_cache(expires_at);

-- Privacy: allow users to opt out
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS recs_enabled BOOLEAN DEFAULT true;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS recs_clear_requested BOOLEAN DEFAULT false;

-- RLS for new tables
ALTER TABLE user_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_rec_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE media_similarity ENABLE ROW LEVEL SECURITY;
ALTER TABLE recommendations_cache ENABLE ROW LEVEL SECURITY;

-- Events: insert own, no read unless aggregated
CREATE POLICY "Users insert own events" ON user_events FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users view own events" ON user_events FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users delete own events" ON user_events FOR DELETE USING (auth.uid() = user_id);

-- Profiles: own read/write, service role full access
CREATE POLICY "Users view own rec profile" ON user_rec_profiles FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "System manages rec profiles" ON user_rec_profiles FOR ALL USING (auth.uid() = user_id);

-- Similarity: publicly readable (no PII)
CREATE POLICY "Similarity is public" ON media_similarity FOR SELECT USING (true);

-- Cache: own read, system write
CREATE POLICY "Users view own recommendations" ON recommendations_cache FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users dismiss own recommendations" ON recommendations_cache FOR UPDATE USING (auth.uid() = user_id);

-- Auto-create rec profile on signup
CREATE OR REPLACE FUNCTION handle_new_user_rec_profile()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO user_rec_profiles (user_id)
  VALUES (NEW.id)
  ON CONFLICT (user_id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_profile_created_rec_profile
  AFTER INSERT ON profiles
  FOR EACH ROW EXECUTE FUNCTION handle_new_user_rec_profile();

-- Updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_media_updated_at
  BEFORE UPDATE ON media FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_user_media_updated_at
  BEFORE UPDATE ON user_media FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_user_reviews_updated_at
  BEFORE UPDATE ON user_reviews FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_user_lists_updated_at
  BEFORE UPDATE ON user_lists FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_custom_media_updated_at
  BEFORE UPDATE ON custom_media FOR EACH ROW EXECUTE FUNCTION update_updated_at();
