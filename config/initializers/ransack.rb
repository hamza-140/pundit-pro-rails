Ransack.configure do |c|
  # Change default search parameter key name.
  # Default key name is :q
  c.search_key = :query
    # Default is true
    c.strip_whitespace = false
end
