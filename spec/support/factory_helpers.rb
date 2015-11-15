module FactoryHelpers
  
  # Uri redirections form http to https
  def process_uri(uri)
     avatar_url = URI.parse(uri)
     avatar_url.scheme = 'https'
     avatar_url.to_s
  end
end