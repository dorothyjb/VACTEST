class Bvadmin::RmsStatusInfo < Bvadmin::Record
  self.table_name = "BVADMIN.RMS_STATUS_INFO"
  self.primary_key = :id
  

  attr_writer :str_appointment_onboard_date
  attr_writer :str_promotion_date
  attr_writer :str_seperation_effective_date

  belongs_to :employee
  validate :app_date_is_valid
  validate :pro_date_is_valid
  validate :sep_date_is_valid
  
  
  #This is horribly repetative and very much needs to be fixed.
  #Passing testing though....
  
  def rolls_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def appointment_onboard_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def promotion_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def seperation_effective_date= date
    return super(date) unless date.is_a? String

    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/

    super date
  end

  def str_appointment_onboard_date
    @str_appointment_onboard_date || self.appointment_onboard_date.to_s
  end


  def str_promotion_date
    @str_promotion_date || self.promotion_date.to_s
  end


  def str_seperation_effective_date
    @str_seperation_effective_date || self.seperation_effective_date.to_s
  end







  def app_date_is_valid
        return if @str_appointment_onboard_date.blank?

            unless @str_appointment_onboard_date =~ /^(\d{8}|\d{1,2}\/\d{1,2}\/\d{4}|\d{4}-\d{1,2}-\d{1,2})$/
                    errors.add :date, 'invalid date format supplied, accepted forms are: YYYY-MM-DD, MMDDYYYY, and MM/DD/YYYY'
                          return
                              end

                if @str_appointment_onboard_date =~ /^\d{8}$/
                        tmp = Date.strptime(@str_appointment_onboard_date, "%m%d%Y")
                            elsif @str_appointment_onboard_date =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/
                                    tmp = Date.strptime(@str_appointment_onboard_date, "%m/%d/%Y") 
                                        else
                                                tmp = Date.strptime(@str_appointment_onboard_date, "%Y-%m-%d") 
                                                    end

                    self.appointment_onboard_date = tmp
                      end



  def pro_date_is_valid
        return if @str_promotion_date.blank?

            unless @str_promotion_date =~ /^(\d{8}|\d{1,2}\/\d{1,2}\/\d{4}|\d{4}-\d{1,2}-\d{1,2})$/
                    errors.add :date, 'invalid date format supplied, accepted forms are: YYYY-MM-DD, MMDDYYYY, and MM/DD/YYYY'
                          return
                              end

                if @str_promotion_date =~ /^\d{8}$/
                        tmp = Date.strptime(@str_promotion_date, "%m%d%Y")
                            elsif @str_promotion_date =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/
                                    tmp = Date.strptime(@str_promotion_date, "%m/%d/%Y") 
                                        else
                                                tmp = Date.strptime(@str_promotion_date, "%Y-%m-%d") 
                                                    end

                    self.promotion_date = tmp
                      end


  def sep_date_is_valid
        return if @str_seperation_effective_date.blank?

            unless @str_seperation_effective_date =~ /^(\d{8}|\d{1,2}\/\d{1,2}\/\d{4}|\d{4}-\d{1,2}-\d{1,2})$/
                    errors.add :date, 'invalid date format supplied, accepted forms are: YYYY-MM-DD, MMDDYYYY, and MM/DD/YYYY'
                          return
                              end

                if @str_seperation_effective_date =~ /^\d{8}$/
                        tmp = Date.strptime(@str_seperation_effective_date, "%m%d%Y")
                            elsif @str_seperation_effective_date =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/
                                    tmp = Date.strptime(@str_seperation_effective_date, "%m/%d/%Y") 
                                        else
                                                tmp = Date.strptime(@str_seperation_effective_date, "%Y-%m-%d") 
                                                    end

                    self.seperation_effective_date = tmp
                      end





end
