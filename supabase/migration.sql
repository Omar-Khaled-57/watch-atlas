-- Add missing columns to the profiles table (safe to run multiple times)

ALTER TABLE profiles ADD COLUMN IF NOT EXISTS display_name TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS avatar_url TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS banner_url TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS bio TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS gender TEXT CHECK (gender IN ('male', 'female', 'ratherNotSay'));
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS dob DATE;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS default_avatar TEXT;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS role TEXT NOT NULL DEFAULT 'user' CHECK (role IN ('user', 'moderator', 'admin'));
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS is_verified BOOLEAN DEFAULT false;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS followers_count INTEGER DEFAULT 0;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS following_count INTEGER DEFAULT 0;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS lists_count INTEGER DEFAULT 0;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS reviews_count INTEGER DEFAULT 0;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

-- Change user_media.id from UUID to TEXT to match Dart's composite key format (userId_mediaId)
-- Drop dependent policy, foreign key, then re-add both
DROP POLICY IF EXISTS "Users manage own progress" ON user_progress;
ALTER TABLE user_progress DROP CONSTRAINT IF EXISTS user_progress_user_media_id_fkey;
ALTER TABLE user_progress ALTER COLUMN user_media_id TYPE TEXT;
ALTER TABLE user_media DROP CONSTRAINT IF EXISTS user_media_pkey;
ALTER TABLE user_media ALTER COLUMN id TYPE TEXT;
ALTER TABLE user_media ALTER COLUMN id DROP DEFAULT;
ALTER TABLE user_media ALTER COLUMN id SET NOT NULL;
ALTER TABLE user_media ADD PRIMARY KEY (id);
ALTER TABLE user_progress ADD CONSTRAINT user_progress_user_media_id_fkey
  FOREIGN KEY (user_media_id) REFERENCES user_media(id) ON DELETE CASCADE;
CREATE POLICY "Users manage own progress" ON user_progress
  FOR ALL USING (auth.uid() IN (
    SELECT user_id FROM user_media WHERE id = user_media_id
  ));

-- Storage buckets for avatars and banners
INSERT INTO storage.buckets (id, name, public) VALUES ('avatars', 'avatars', true)
  ON CONFLICT (id) DO NOTHING;
INSERT INTO storage.buckets (id, name, public) VALUES ('banners', 'banners', true)
  ON CONFLICT (id) DO NOTHING;

DO $$
BEGIN
  DROP POLICY IF EXISTS "Users can upload own avatars" ON storage.objects;
  CREATE POLICY "Users can upload own avatars"
    ON storage.objects FOR INSERT TO authenticated
    WITH CHECK (
      bucket_id = 'avatars' AND (storage.foldername(name))[1] = auth.uid()::text
    );
END $$;

DO $$
BEGIN
  DROP POLICY IF EXISTS "Users can update own avatars" ON storage.objects;
  CREATE POLICY "Users can update own avatars"
    ON storage.objects FOR UPDATE TO authenticated
    USING (
      bucket_id = 'avatars' AND (storage.foldername(name))[1] = auth.uid()::text
    );
END $$;

DO $$
BEGIN
  DROP POLICY IF EXISTS "Avatars are publicly readable" ON storage.objects;
  CREATE POLICY "Avatars are publicly readable"
    ON storage.objects FOR SELECT TO public
    USING (bucket_id = 'avatars');
END $$;

DO $$
BEGIN
  DROP POLICY IF EXISTS "Users can upload own banners" ON storage.objects;
  CREATE POLICY "Users can upload own banners"
    ON storage.objects FOR INSERT TO authenticated
    WITH CHECK (
      bucket_id = 'banners' AND (storage.foldername(name))[1] = auth.uid()::text
    );
END $$;

DO $$
BEGIN
  DROP POLICY IF EXISTS "Users can update own banners" ON storage.objects;
  CREATE POLICY "Users can update own banners"
    ON storage.objects FOR UPDATE TO authenticated
    USING (
      bucket_id = 'banners' AND (storage.foldername(name))[1] = auth.uid()::text
    );
END $$;

DO $$
BEGIN
  DROP POLICY IF EXISTS "Banners are publicly readable" ON storage.objects;
  CREATE POLICY "Banners are publicly readable"
    ON storage.objects FOR SELECT TO public
    USING (bucket_id = 'banners');
END $$;

-- ============================================================
-- Add missing columns
-- ============================================================

ALTER TABLE user_media ADD COLUMN IF NOT EXISTS completed_at TIMESTAMPTZ;
ALTER TABLE user_media ADD COLUMN IF NOT EXISTS started_at TIMESTAMPTZ;
ALTER TABLE user_media ADD COLUMN IF NOT EXISTS rewatch_count INTEGER DEFAULT 0;

-- ============================================================
-- Change user_lists.id from UUID to TEXT to match Dart's composite key format (userId_timestamp)
-- Drop dependent policies/constraints, then re-add
-- ============================================================

DROP POLICY IF EXISTS "List items readable with list" ON list_items;
DROP POLICY IF EXISTS "Users manage own list items" ON list_items;
ALTER TABLE list_items DROP CONSTRAINT IF EXISTS list_items_list_id_fkey;
ALTER TABLE list_items ALTER COLUMN list_id TYPE TEXT;
ALTER TABLE user_lists DROP CONSTRAINT IF EXISTS user_lists_pkey;
ALTER TABLE user_lists ALTER COLUMN id TYPE TEXT;
ALTER TABLE user_lists ALTER COLUMN id DROP DEFAULT;
ALTER TABLE user_lists ALTER COLUMN id SET NOT NULL;
ALTER TABLE user_lists ADD PRIMARY KEY (id);
ALTER TABLE list_items ADD CONSTRAINT list_items_list_id_fkey
  FOREIGN KEY (list_id) REFERENCES user_lists(id) ON DELETE CASCADE;
DO $$
BEGIN
  DROP POLICY IF EXISTS "List items readable with list" ON list_items;
  CREATE POLICY "List items readable with list" ON list_items
    FOR SELECT USING (
      EXISTS (SELECT 1 FROM user_lists WHERE id = list_id AND (list_type = 'public' OR user_id = auth.uid()))
    );
END $$;

DO $$
BEGIN
  DROP POLICY IF EXISTS "Users manage own list items" ON list_items;
  CREATE POLICY "Users manage own list items" ON list_items
    USING (
      EXISTS (SELECT 1 FROM user_lists WHERE id = list_id AND user_id = auth.uid())
    )
    WITH CHECK (
      EXISTS (SELECT 1 FROM user_lists WHERE id = list_id AND user_id = auth.uid())
    );
END $$;

-- ============================================================
-- Re-create user_lists policies with explicit operations
-- (the old FOR ALL policy may not cover INSERT in all PG versions)
-- ============================================================

DO $$
BEGIN
  DROP POLICY IF EXISTS "Users manage own lists" ON user_lists;
  DROP POLICY IF EXISTS "Users view own lists" ON user_lists;
  DROP POLICY IF EXISTS "Users insert own lists" ON user_lists;
  DROP POLICY IF EXISTS "Users update own lists" ON user_lists;
  DROP POLICY IF EXISTS "Users delete own lists" ON user_lists;
  CREATE POLICY "Users view own lists" ON user_lists
    FOR SELECT USING (auth.uid() = user_id OR list_type = 'public');
  CREATE POLICY "Users insert own lists" ON user_lists
    FOR INSERT TO authenticated
    WITH CHECK (auth.uid() = user_id);
  CREATE POLICY "Users update own lists" ON user_lists
    FOR UPDATE USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);
  CREATE POLICY "Users delete own lists" ON user_lists
    FOR DELETE USING (auth.uid() = user_id);
END $$;

-- ============================================================
-- Add INSERT/UPDATE RLS policy on media table
-- (GRANT alone is not enough; an RLS policy must permit the operation)
-- ============================================================

DO $$
BEGIN
  DROP POLICY IF EXISTS "Authenticated users can insert media" ON media;
  CREATE POLICY "Authenticated users can insert media"
    ON media FOR INSERT TO authenticated
    WITH CHECK (true);
END $$;

DO $$
BEGIN
  DROP POLICY IF EXISTS "Authenticated users can update media" ON media;
  CREATE POLICY "Authenticated users can update media"
    ON media FOR UPDATE TO authenticated
    USING (true)
    WITH CHECK (true);
END $$;

-- ============================================================
-- Grant INSERT, UPDATE on media table for authenticated users
-- (needed by addItemToList which upserts media before adding to list)
-- ============================================================

GRANT INSERT, UPDATE ON public.media TO authenticated;

-- ============================================================
-- Recommendation engine columns (needed for personalized recommendations)
-- ============================================================

ALTER TABLE profiles ADD COLUMN IF NOT EXISTS recs_enabled BOOLEAN DEFAULT true;
ALTER TABLE profiles ADD COLUMN IF NOT EXISTS recs_clear_requested BOOLEAN DEFAULT false;

-- Note: user_events, user_rec_profiles, media_similarity, recommendations_cache
-- are defined in schema.sql. Run schema.sql in your Supabase SQL editor
-- if you haven't already done so.

-- ============================================================
-- Account deletion RPC — deletes the calling user's auth record,
-- which cascades to profiles and all child tables via FK constraints.
-- ============================================================

CREATE OR REPLACE FUNCTION delete_my_account()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  uid uuid;
BEGIN
  uid := auth.uid();
  IF uid IS NULL THEN
    RAISE EXCEPTION 'Not authenticated';
  END IF;
  DELETE FROM auth.users WHERE id = uid;
END;
$$;

GRANT EXECUTE ON FUNCTION delete_my_account TO authenticated;