class Site < ApplicationRecord


  validates :name, presence: {message: "اسم الموقع حقل مطلوب"}
  validates :address, presence: {message: 'الحي / البلدية حقل مطلوب'}
  validates :last_visit, presence: {message: 'تاريخ اخر زيارة مطلوب'}
  validate :last_visit_date


  COLORS = {
    past_15: "success",
    past_30: "primary",
    past_45: "warning",
    more: "danger"
  }

  scope :past_15, -> {
    where(arel_table[:last_visit].gt(create_datetime_for_past_days(15)))
  }

  scope :past_30, -> {
    where(arel_table[:last_visit].gt(create_datetime_for_past_days(30)).and(arel_table[:last_visit].lt(create_datetime_for_past_days(15))))
  }

  scope :past_45, -> {
    where(arel_table[:last_visit].gt(create_datetime_for_past_days(45)).and(arel_table[:last_visit].lt(create_datetime_for_past_days(30))))
  }

  scope :past_more_than_45, -> {
    where(arel_table[:last_visit].lt(create_datetime_for_past_days(45)))
  }

  scope :order_by_last_visit, -> (by){ order(last_visit: by=="asc" ? "asc" : "desc")}

  scope :order_by_name, -> (by){ order(name: by=="desc" ? "desc" : "asc")}
  
  scope :order_by_address, -> (by){ order(address: by=="desc" ? "desc" : "asc")}
  
  scope :last_visit_between, -> (start_date, end_date) {where(last_visit: format_date_range(start_date,end_date)) if format_date_range(start_date,end_date)}
  
  scope :name_match, -> (str) {where(arel_table[:name].matches("%#{str}%")) if str}
  
  scope :address_match, -> (str) {where(arel_table[:address].matches("%#{str}%")) if str}

  def in_past_15?
    last_visit > create_datetime_for_past_days(15)
  end

  def in_past_30?
    last_visit > create_datetime_for_past_days(30) &&
                  last_visit < create_datetime_for_past_days(15)
  end

  def in_past_45?
    last_visit > create_datetime_for_past_days(45) &&
                  last_visit < create_datetime_for_past_days(30)
  end

  def in_past?
    last_visit < create_datetime_for_past_days(45)
  end

  def colors
    if in_past_15? 
      return COLORS[:past_15]
    elsif in_past_30?
      return COLORS[:past_30]
    elsif in_past_45?
      return COLORS[:past_45]
    else
      return COLORS[:more]
    end
  end


  private
  def last_visit_date
    return unless last_visit

    return unless last_visit > DateTime.now

    errors.add(:last_visit, "تاريخ اخر زيارة يجب الا يتعدى تاريخ اليوم")
  end


  def create_datetime_for_past_days(past)
    Site.create_datetime_for_past_days(past)
  end

  def self.create_datetime_for_past_days(past)
    past.days.ago.to_datetime
  end

  def self.format_date_range(start_date,end_date)
    begin
      s= start_date.to_datetime
      e = end_date.to_datetime
      if e > s
        return (s .. e)
      else
        return (e .. s)
      end
    rescue
      nil
    end
  end

end
