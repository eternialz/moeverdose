class ZipService
    def self.create_from_json(json, json_name, zip_name)
        require 'zip'
        json_file = Tempfile.new("#{json_name}.json")
        zip_file = Tempfile.new "#{zip_name}.zip"
        begin
            json_file.write(json)
            json_file.close
            # Initialize the temp file as a zip file
            Zip::OutputStream.open(zip_file) { |zos| }

            # open the zip
            Zip::File.open(zip_file.path, Zip::File::CREATE) do |zip|
                filename = "#{json_name}.json"
                # add file into the zip
                zip.add filename, json_file.path
            end

            return File.read(zip_file.path)
        ensure
            json_file.unlink
            zip_file.close
            zip_file.unlink
        end
    end
end
