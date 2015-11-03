def full_title(page_title = nil)
  base_title = "About bank"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def process_uri(uri)
   avatar_url = URI.parse(uri)
   avatar_url.scheme = 'https'
   avatar_url.to_s
end