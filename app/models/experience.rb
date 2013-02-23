class Experience < ActiveRecord::Base
  attr_accessible :company, :description, :from_date, :location, :title, :to_date

  belongs_to :profile

  def formatted_description
    formatted_str = ''

    description_present = self.description.present?
    company_present = self.company.present?

    if(description_present and company_present)
      formatted_str = t('profile.professional.format.work_experience.full_description', description: self.description, company: self.company)
    elsif description_present
      formatted_str = t('profile.professional.format.education.only_description', description: self.description)
    elsif company_present
      formatted_str = t('profile.professional.format.education.only_company', company: self.company)
    else
      formatted_str = t('profile.professional.message.work_experience.no_details')
    end

    formatted_str
  end

  def formatted_duration
    date_format = t('profile.professional.format.work_experience.date')
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
      formatted_str = t('profile.professional.message.work_experience.no_duration')
    else
      formatted_from_date = t('profile.professional.message.work_experience.date_unavailable') if formatted_from_date.nil?
      formatted_to_date = t('profile.professional.message.work_experience.date_unavailable') if formatted_to_date.nil?

      formatted_str = t('profile.professional.format.work_experience.full_duration', from_date: formatted_from_date, to_date: formatted_to_date)
    end

    formatted_str
  end

end
