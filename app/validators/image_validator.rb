class ImageValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
        unless value.attached? && value&.image?
            record.errors.add(attribute, 'This is not an image')
        end
    end
end
