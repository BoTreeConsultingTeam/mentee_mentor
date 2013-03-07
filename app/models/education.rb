class Education < ActiveRecord::Base
  attr_accessible :degree, :from_date, :school, :study_field, :to_date

  belongs_to :profile

  # From front-end when a start and end date is selected under Education
  # section in Edit Profile mode, it should be displayed in format 'MMM yyyy'.
  # The correct selected value is sent with request params Profile has
  # accepts_nested_attributes_for available for :experiences.
  # When the request is received by the controller and
  # @user.update_attributes(params[:user]) is done somehow the values received
  # for params[:user][:profile_attributes][:educations_attributes][:from_date]
  # and params[:user][:profile_attributes][:educations_attributes][:to_date]
  # doesn't not get assigned to the Education object and thus experience's
  # from_date and to_date values remain set to nil.
  # The data type for both from_date and to_date is Date.Is it possible that
  # ActiveRecord is unable to parse the received string to a Date object and
  # thus assigns nil? I have no idea and just guessing it.However I found
  # the following solution to resolve the problem being faced which is to
  # manually override the setters.Found the reference here:
  # http://stackoverflow.com/questions/4349254/rails-way-formatting-value-before-setting-it-in-the-model
  # Jignesh Gohel, Feb 23, 2013
  def from_date=(from_date)
    write_attribute(:from_date, Date.parse(from_date)) if from_date.present?
  end

  def to_date=(to_date)
    write_attribute(:to_date, Date.parse(to_date)) if to_date.present?
  end

  def formatted_description
    formatted_str = ''

    school_present = self.school.present?
    study_field_present = self.study_field.present?

    if(school_present and study_field_present)
      formatted_str = I18n.t('profile.professional.format.education.full_description', study_field: self.study_field, school: self.school)
    elsif school_present
      formatted_str = I18n.t('profile.professional.format.education.only_school', school: self.school)
    elsif study_field_present
      formatted_str = I18n.t('profile.professional.format.education.only_study_field', study_field: self.study_field)
    else
      formatted_str = I18n.t('profile.professional.message.education.no_details')
    end

    formatted_str
  end

  def formatted_duration
    formatted_str = ''

    ffromd = self.formatted_from_date
    ftod = self.formatted_to_date

    if (!ffromd.present? and !ftod.present?)
      formatted_str = I18n.t('profile.professional.message.education.no_duration')
    else
      ffromd = I18n.t('profile.professional.message.education.date_unavailable') unless ffromd.present?
      ftod = I18n.t('profile.professional.message.education.date_unavailable') unless ftod.present?
      formatted_str = I18n.t('profile.professional.format.education.full_duration', from_date: ffromd, to_date: ftod)
    end

    formatted_str
  end

  def date_format
    I18n.t('profile.professional.format.education.date')
  end

  def format_date(date)
    return date unless date.present?
    date.strftime(date_format)
  end

  def formatted_from_date
    format_date(self.from_date)
  end

  def formatted_to_date
    format_date(self.to_date)
  end

end
