/*
  # Create track videos table

  1. New Tables
    - `track_videos`
      - `id` (uuid, primary key)
      - `artist_name` (text) - Nom de l'artiste
      - `track_title` (text) - Titre de la chanson
      - `video_url` (text) - URL complète de la vidéo dans Supabase Storage
      - `created_at` (timestamptz)
      - `updated_at` (timestamptz)
  
  2. Security
    - Enable RLS on `track_videos` table
    - Add policy for public read access (everyone can view videos)
    - Add policy for authenticated users to insert/update/delete videos

  3. Indexes
    - Composite index on (artist_name, track_title) for fast lookups
*/

CREATE TABLE IF NOT EXISTS track_videos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  artist_name text NOT NULL,
  track_title text NOT NULL,
  video_url text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  UNIQUE(artist_name, track_title)
);

ALTER TABLE track_videos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view track videos"
  ON track_videos
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Authenticated users can insert track videos"
  ON track_videos
  FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Authenticated users can update track videos"
  ON track_videos
  FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Authenticated users can delete track videos"
  ON track_videos
  FOR DELETE
  TO authenticated
  USING (true);

CREATE INDEX IF NOT EXISTS idx_track_videos_artist_track 
  ON track_videos(artist_name, track_title);
