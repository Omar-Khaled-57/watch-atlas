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

-- Allow authenticated users to upload their own avatars
CREATE POLICY "Users can upload own avatars"
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'avatars' AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Allow authenticated users to update their own avatars
CREATE POLICY "Users can update own avatars"
  ON storage.objects FOR UPDATE TO authenticated
  USING (
    bucket_id = 'avatars' AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Allow public read for avatars
CREATE POLICY "Avatars are publicly readable"
  ON storage.objects FOR SELECT TO public
  USING (bucket_id = 'avatars');

-- Allow authenticated users to upload their own banners
CREATE POLICY "Users can upload own banners"
  ON storage.objects FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'banners' AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Allow authenticated users to update their own banners
CREATE POLICY "Users can update own banners"
  ON storage.objects FOR UPDATE TO authenticated
  USING (
    bucket_id = 'banners' AND (storage.foldername(name))[1] = auth.uid()::text
  );

-- Allow public read for banners
CREATE POLICY "Banners are publicly readable"
  ON storage.objects FOR SELECT TO public
  USING (bucket_id = 'banners');
