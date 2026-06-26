-- Grant table-level permissions for RLS-enabled tables.
-- Uses EXECUTE inside a DO $$ block so tables that don't exist yet are skipped without error.

DO $$
BEGIN
  -- profiles
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='profiles') THEN
    EXECUTE 'GRANT SELECT, INSERT, UPDATE ON public.profiles TO authenticated';
    EXECUTE 'GRANT SELECT ON public.profiles TO anon';
  END IF;

  -- media
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='media') THEN
    EXECUTE 'GRANT SELECT ON public.media TO authenticated';
    EXECUTE 'GRANT SELECT ON public.media TO anon';
  END IF;

  -- user_media
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='user_media') THEN
    EXECUTE 'GRANT SELECT, INSERT, UPDATE, DELETE ON public.user_media TO authenticated';
    EXECUTE 'GRANT SELECT ON public.user_media TO anon';
  END IF;

  -- user_lists
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='user_lists') THEN
    EXECUTE 'GRANT SELECT, INSERT, UPDATE, DELETE ON public.user_lists TO authenticated';
    EXECUTE 'GRANT SELECT ON public.user_lists TO anon';
  END IF;

  -- list_items
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='list_items') THEN
    EXECUTE 'GRANT SELECT, INSERT, UPDATE, DELETE ON public.list_items TO authenticated';
    EXECUTE 'GRANT SELECT ON public.list_items TO anon';
  END IF;

  -- user_progress
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='user_progress') THEN
    EXECUTE 'GRANT SELECT, INSERT, UPDATE, DELETE ON public.user_progress TO authenticated';
  END IF;

  -- user_ratings
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='user_ratings') THEN
    EXECUTE 'GRANT SELECT, INSERT, UPDATE, DELETE ON public.user_ratings TO authenticated';
  END IF;

  -- user_reviews
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='user_reviews') THEN
    EXECUTE 'GRANT SELECT, INSERT, UPDATE, DELETE ON public.user_reviews TO authenticated';
    EXECUTE 'GRANT SELECT ON public.user_reviews TO anon';
  END IF;

  -- followers
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='followers') THEN
    EXECUTE 'GRANT SELECT, INSERT, DELETE ON public.followers TO authenticated';
    EXECUTE 'GRANT SELECT ON public.followers TO anon';
  END IF;

  -- notifications
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='notifications') THEN
    EXECUTE 'GRANT SELECT, UPDATE ON public.notifications TO authenticated';
  END IF;

  -- activity_logs
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='activity_logs') THEN
    EXECUTE 'GRANT INSERT ON public.activity_logs TO authenticated';
  END IF;

  -- reports
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='reports') THEN
    EXECUTE 'GRANT INSERT ON public.reports TO authenticated';
  END IF;

  -- sync_queue
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='sync_queue') THEN
    EXECUTE 'GRANT SELECT, INSERT, UPDATE, DELETE ON public.sync_queue TO authenticated';
  END IF;

  -- comments
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='comments') THEN
    EXECUTE 'GRANT SELECT, INSERT ON public.comments TO authenticated';
    EXECUTE 'GRANT SELECT ON public.comments TO anon';
  END IF;

  -- custom_media
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='custom_media') THEN
    EXECUTE 'GRANT SELECT, INSERT, UPDATE, DELETE ON public.custom_media TO authenticated';
    EXECUTE 'GRANT SELECT ON public.custom_media TO anon';
  END IF;

  -- recommendations
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='recommendations') THEN
    EXECUTE 'GRANT SELECT ON public.recommendations TO authenticated';
  END IF;

  -- watch_history
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='watch_history') THEN
    EXECUTE 'GRANT SELECT, INSERT ON public.watch_history TO authenticated';
  END IF;

  -- media_external_ids
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='media_external_ids') THEN
    EXECUTE 'GRANT SELECT ON public.media_external_ids TO authenticated';
    EXECUTE 'GRANT SELECT ON public.media_external_ids TO anon';
  END IF;

  -- recommendation-engine tables (optional; may not exist yet)
  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='user_events') THEN
    EXECUTE 'GRANT SELECT ON public.user_events TO authenticated';
  END IF;

  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='user_rec_profiles') THEN
    EXECUTE 'GRANT SELECT, UPDATE ON public.user_rec_profiles TO authenticated';
  END IF;

  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='media_similarity') THEN
    EXECUTE 'GRANT SELECT ON public.media_similarity TO authenticated';
  END IF;

  IF EXISTS (SELECT FROM pg_tables WHERE schemaname='public' AND tablename='recommendations_cache') THEN
    EXECUTE 'GRANT SELECT, UPDATE ON public.recommendations_cache TO authenticated';
  END IF;
END $$;
