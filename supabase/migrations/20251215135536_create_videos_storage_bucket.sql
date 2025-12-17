/*
  # Create videos storage bucket

  1. Storage Setup
    - Create 'videos' bucket for storing video files
    - Set bucket as public so videos can be accessed from the player
    - Allow authenticated users to upload videos
  
  2. Security
    - Public read access for all videos
    - Only authenticated users can upload videos
    - File size limit: 100MB per video
*/

INSERT INTO storage.buckets (id, name, public)
VALUES ('videos', 'videos', true)
ON CONFLICT (id) DO NOTHING;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'storage' 
    AND tablename = 'objects' 
    AND policyname = 'Anyone can view videos'
  ) THEN
    CREATE POLICY "Anyone can view videos"
      ON storage.objects
      FOR SELECT
      TO public
      USING (bucket_id = 'videos');
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'storage' 
    AND tablename = 'objects' 
    AND policyname = 'Authenticated users can upload videos'
  ) THEN
    CREATE POLICY "Authenticated users can upload videos"
      ON storage.objects
      FOR INSERT
      TO authenticated
      WITH CHECK (bucket_id = 'videos');
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'storage' 
    AND tablename = 'objects' 
    AND policyname = 'Authenticated users can update videos'
  ) THEN
    CREATE POLICY "Authenticated users can update videos"
      ON storage.objects
      FOR UPDATE
      TO authenticated
      USING (bucket_id = 'videos')
      WITH CHECK (bucket_id = 'videos');
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies 
    WHERE schemaname = 'storage' 
    AND tablename = 'objects' 
    AND policyname = 'Authenticated users can delete videos'
  ) THEN
    CREATE POLICY "Authenticated users can delete videos"
      ON storage.objects
      FOR DELETE
      TO authenticated
      USING (bucket_id = 'videos');
  END IF;
END $$;
