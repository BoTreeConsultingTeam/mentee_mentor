class Profile < ActiveRecord::Base
  attr_accessible :birthday, :current_location, :first_name, :hometown, :last_name
  attr_accessible :biography, :gender, :interests, :recent_activities
  # Reference: https://github.com/thoughtbot/paperclip#readme --> "Quick Start"
  attr_accessible :photo

  # The default place to store attachments is in the filesystem
  # References:
  # 1) http://rdoc.info/github/thoughtbot/paperclip/Paperclip/Storage/Filesystem
  # 2) https://github.com/thoughtbot/paperclip#readme --> "Understanding Storage"
  paperclip_options = {
    styles: {
      medium: "#{Settings.photos.profile.styles.medium}>",
      thumb: "#{Settings.photos.profile.styles.thumb}>"
    },
    default_url: Settings.photos.profile.default_image_path
  }

  paperclip_options = Paperclip::Attachment.default_options.merge(paperclip_options)
  has_attached_file :photo, paperclip_options

  # Paperclip Validations
  validates_attachment :photo, content_type: { content_type: /image/ }, size: { in: (0..1000.kilobytes) }

  belongs_to :user

  has_many :educations, dependent: :destroy, order: "educations.from_date DESC, educations.to_date DESC"
  accepts_nested_attributes_for :educations, allow_destroy: true
  attr_accessible :educations_attributes

  has_many :experiences, dependent: :destroy, order: "experiences.from_date DESC, experiences.to_date DESC"
  accepts_nested_attributes_for :experiences, allow_destroy: true
  attr_accessible :experiences_attributes

  # From front-end the birthday value is received in a hash containing 3
  # explicit values for day, month and year.This is because the date component
  # for birthday is displayed using select_date helper.
  # When the request is received by the controller and
  # @user.update_attributes(params[:user]) is done somehow the values received
  # for params[:user][:profile_attributes][:birthday]
  # doesn't not get assigned to the Profile object and thus profile's
  # birthday value remain set to nil.
  # The data type for "birthday" is Date.Is it possible that
  # ActiveRecord is unable to parse the received hash to a Date object and
  # thus assigns nil? I have no idea and just guessing it.However I found
  # the following solution to resolve the problem being faced which is to
  # manually override the setters.Found the reference here:
  # http://stackoverflow.com/questions/4349254/rails-way-formatting-value-before-setting-it-in-the-model
  # Jignesh Gohel, Feb 24, 2013
  def birthday=(birthday)
    date_str = nil
    if birthday.present?
      if birthday.is_a?(Hash)
        date = birthday[:day]
        month = birthday[:month]
        year = birthday[:year]

        if (date.present? and month.present? and year.present?)
          date_str = "#{date}-#{month}-#{year}"
        end
      else
        date_str = birthday
      end
    end

    write_attribute(:birthday, Date.parse(date_str)) if date_str.present?
  end

end
