-- Core grants — run this first, then supabase/grants.sql
-- These tables are guaranteed to exist in the base schema.

GRANT SELECT, INSERT, UPDATE ON public.profiles TO authenticated;
GRANT SELECT ON public.profiles TO anon;

GRANT SELECT ON public.media TO authenticated;
GRANT SELECT ON public.media TO anon;

GRANT SELECT, INSERT, UPDATE, DELETE ON public.user_media TO authenticated;
GRANT SELECT ON public.user_media TO anon;
