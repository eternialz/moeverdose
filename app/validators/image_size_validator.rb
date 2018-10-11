class ImageSizeValidator < ActiveModel::EachValidator
    def validate_each(recorf, attribute, value)
        return unless options.key? :range
        range = options[:range]
        if range.min > value.blob.byte_size or range.max > value.blob.byte_size
            record.errors.add(attribute, 'The file is too big')
        end
    end
end
