-- Insert mock waitlist entries
INSERT INTO waitlist (email, created_at) VALUES
  ('john.doe@example.com', NOW() - INTERVAL '5 days'),
  ('jane.smith@example.com', NOW() - INTERVAL '3 days'),
  ('alex.johnson@example.com', NOW() - INTERVAL '2 days'),
  ('sarah.wilson@example.com', NOW() - INTERVAL '1 day'),
  ('mike.brown@example.com', NOW() - INTERVAL '12 hours')
ON CONFLICT (email) DO NOTHING;
