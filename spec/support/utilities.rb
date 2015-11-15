def full_title(page_title = nil)
  base_title = "About bank"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end