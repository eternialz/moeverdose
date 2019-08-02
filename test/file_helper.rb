def sample_path(name='sample.png')
    Rails.root.join('test', 'images', name)
end

def sample_file(name='sample.png')
    fixture_file_upload(sample_path(name), 'image/png')
end
