class Education < ActiveRecord::Base
  attr_accessible :degree, :from_date, :school, :study_field, :to_date

  belongs_to :profile

  def formatted_description
    formatted_str = ''

    school_present = self.school.present?
    study_field_present = self.study_field.present?

    if(school_present and study_field_present)
      formatted_str = t('profile.professional.format.education.full_description', study_field: self.study_field, school: self.school)
    elsif school_present
      formatted_str = t('profile.professional.format.education.only_school', school: self.school)
    elsif study_field_present
      formatted_str = t('profile.professional.format.education.only_study_field', study_field: self.study_field)
    else
      formatted_str = t('profile.professional.message.education.no_details')
    end

    formatted_str
  end

  def formatted_duration
    date_format = t('profile.professional.format.education.date')
    formatted_str = ''

    from_date_present = self.from_date.present?
    to_date_present = self.to_date.present?

    if (from_date_present and to_date_present)
      formatted_from_date =  self.from_date.strftime(date_format)
      formatted_to_date =  self.to_date.strftime(date_format)
    elsif from_date_present
      formatted_from_date =  self.from_date.strftime(date_format)
    elsif to_date_present
      formatted_to_date =  self.to_date.strftime(date_format)
    end

    if (!formatted_from_date.present? and !formatted_to_date.present?)
      formatted_str = t('profile.professional.message.education.no_duration')
    else
      formatted_from_date = t('profile.professional.message.education.date_unavailable') if formatted_from_date.nil?
      formatted_to_date = t('profile.professional.message.education.date_unavailable') if formatted_to_date.nil?

      formatted_str = t('profile.professional.format.education.full_duration', from_date: formatted_from_date, to_date: formatted_to_date)
    end

    formatted_str
  end

end
