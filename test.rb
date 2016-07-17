require'sinatra'

get '/uploader/dEtx4' do
  http_headers = request.env#.select { |k, v| k.start_with?('HTTP_')}
  p "#{http_headers}"
  "<h1>Not Found</h1>"
end
