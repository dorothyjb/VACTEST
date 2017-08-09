class Bvadmin::EmployeeApplication < Bvadmin::Record
  self.table_name = "BVADMIN.EMPLOYEE_APPLICATIONS"
  self.primary_key = :application_id
  belongs_to :employee_applicants
  
  validate :selection_date_is_valid
  validate :process_start_date_is_valid
  validate :tentative_offer_date_is_valid
  validate :sent_to_security_date_is_valid
  validate :final_offer_date_is_valid
  validate :requested_eod_is_valid
  validate :confirmed_eod_is_valid
  validate :denied_action_date
  validate :incoming_action_date
  validate :pipeline_action_date
  validate :sent_start_date

scope :active_applications, -> (applicant_id, active_status){where("applicant_id = ? and status in (?)", applicant_id, active_status).order('vacancy_number ASC')}

#this code should be taken out back and shot.  We really need to do a global date thing

  def selection_date= date
        return super(date) unless date.is_a? String
        date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
        date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
        date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/
        super date
  end

  def str_selection_date
    @str_selection_date || self.selection_date.to_s
  end

  def selection_date_is_valid
    return if @str_selection_date.blank?                   
    unless @str_selection_date =~ /^(\d{8}|\d{1,2}\/\d{1,2}\/\d{4}|\d{4}-\d{1,2}-\d{1,2})$/                                        
      errors.add :date, 'invalid date format supplied, accepted forms are: YYYY-MM-DD, MMDDYYYY, and MM/DD/YYYY'                                                                  
      return                                                                                                  
    end            
    if @str_selection_date =~ /^\d{8}$/
      tmp = Date.strptime(@str_selection_date, "%m%d%Y")
    elsif @str_selection_date =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/                                                                  
      tmp = Date.strptime(@str_selection_date, "%m/%d/%Y")  
    else
      tmp = Date.strptime(@str_selection_date, "%Y-%m-%d")
    end
    self.selection_date = tmp  
  end


  def process_start_date= date
        return super(date) unless date.is_a? String
        date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
        date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
        date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/
        super date
  end

  def str_process_start_date
    @str_process_start_date || self.process_start_date.to_s
  end

  def process_start_date_is_valid
    return if @str_process_start_date.blank?                   
    unless @str_process_start_date =~ /^(\d{8}|\d{1,2}\/\d{1,2}\/\d{4}|\d{4}-\d{1,2}-\d{1,2})$/                                        
      errors.add :date, 'invalid date format supplied, accepted forms are: YYYY-MM-DD, MMDDYYYY, and MM/DD/YYYY'                                                                  
      return                                                                                                  
    end            
    if @str_process_start_date =~ /^\d{8}$/
      tmp = Date.strptime(@str_process_start_date, "%m%d%Y")
    elsif @str_process_start_date =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/                                                                  
      tmp = Date.strptime(@str_process_start_date, "%m/%d/%Y")  
    else
      tmp = Date.strptime(@str_process_start_date, "%Y-%m-%d")
    end
    self.process_start_date = tmp  
  end

  def tentative_offer_date= date
    return super(date) unless date.is_a? String
    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/
    super date
  end
  def str_tentative_offer_date    
    @str_tentative_offer_date || self.tentative_offer_date.to_s        
  end

  def tentative_offer_date_is_valid
    return if @str_tentative_offer_date.blank? 
    unless @str_tentative_offer_date =~ /^(\d{8}|\d{1,2}\/\d{1,2}\/\d{4}|\d{4}-\d{1,2}-\d{1,2})$/
      errors.add :date, 'invalid date format supplied, accepted forms are: YYYY-MM-DD, MMDDYYYY, and MM/DD/YYYY'
      return
    end
    if @str_tentative_offer_date =~ /^\d{8}$/
      tmp = Date.strptime(@str_tentative_offer_date, "%m%d%Y")
    elsif @str_tentative_offer_date =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/
      tmp = Date.strptime(@str_tentative_offer_date, "%m/%d/%Y")
    else
      tmp = Date.strptime(@str_tentative_offer_date, "%Y-%m-%d")
    end
    self.tentative_offer_date = tmp
  end


  def sent_to_security_date= date
    return super(date) unless date.is_a? String
    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/
    super date
  end
  def str_sent_to_security_date    
    @str_sent_to_security_date || self.sent_to_security_date.to_s        
  end

  def sent_to_security_date_is_valid
    return if @str_sent_to_security_date.blank? 
    unless @str_sent_to_security_date =~ /^(\d{8}|\d{1,2}\/\d{1,2}\/\d{4}|\d{4}-\d{1,2}-\d{1,2})$/
      errors.add :date, 'invalid date format supplied, accepted forms are: YYYY-MM-DD, MMDDYYYY, and MM/DD/YYYY'
      return
    end
    if @str_sent_to_security_date =~ /^\d{8}$/
      tmp = Date.strptime(@str_sent_to_security_date, "%m%d%Y")
    elsif @str_sent_to_security_date =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/
      tmp = Date.strptime(@str_sent_to_security_date, "%m/%d/%Y")
    else
      tmp = Date.strptime(@str_sent_to_security_date, "%Y-%m-%d")
    end
    self.sent_to_security_date = tmp
  end


  def final_offer_date= date
    return super(date) unless date.is_a? String
    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/
    super date
  end
  def str_final_offer_date    
    @str_final_offer_date || self.final_offer_date.to_s        
  end

  def final_offer_date_is_valid
    return if @str_final_offer_date.blank? 
    unless @str_final_offer_date =~ /^(\d{8}|\d{1,2}\/\d{1,2}\/\d{4}|\d{4}-\d{1,2}-\d{1,2})$/
      errors.add :date, 'invalid date format supplied, accepted forms are: YYYY-MM-DD, MMDDYYYY, and MM/DD/YYYY'
      return
    end
    if @str_final_offer_date =~ /^\d{8}$/
      tmp = Date.strptime(@str_final_offer_date, "%m%d%Y")
    elsif @str_final_offer_date =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/
      tmp = Date.strptime(@str_final_offer_date, "%m/%d/%Y")
    else
      tmp = Date.strptime(@str_final_offer_date, "%Y-%m-%d")
    end
    self.final_offer_date = tmp
  end


  def requested_eod= date
    return super(date) unless date.is_a? String
    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/
    super date
  end
  def str_requested_eod    
    @str_requested_eod || self.requested_eod.to_s        
  end

  def requested_eod_is_valid
    return if @str_requested_eod.blank? 
    unless @str_requested_eod =~ /^(\d{8}|\d{1,2}\/\d{1,2}\/\d{4}|\d{4}-\d{1,2}-\d{1,2})$/
      errors.add :date, 'invalid date format supplied, accepted forms are: YYYY-MM-DD, MMDDYYYY, and MM/DD/YYYY'
      return
    end
    if @str_requested_eod =~ /^\d{8}$/
      tmp = Date.strptime(@str_requested_eod, "%m%d%Y")
    elsif @str_requested_eod =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/
      tmp = Date.strptime(@str_requested_eod, "%m/%d/%Y")
    else
      tmp = Date.strptime(@str_requested_eod, "%Y-%m-%d")
    end
    self.requested_eod = tmp
  end


  def confirmed_eod= date
    return super(date) unless date.is_a? String
    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/
    super date
  end
  def str_confirmed_eod    
    @str_confirmed_eod || self.confirmed_eod.to_s        
  end

  def confirmed_eod_is_valid
    return if @str_confirmed_eod.blank? 
    unless @str_confirmed_eod =~ /^(\d{8}|\d{1,2}\/\d{1,2}\/\d{4}|\d{4}-\d{1,2}-\d{1,2})$/
      errors.add :date, 'invalid date format supplied, accepted forms are: YYYY-MM-DD, MMDDYYYY, and MM/DD/YYYY'
      return
    end
    if @str_confirmed_eod =~ /^\d{8}$/
      tmp = Date.strptime(@str_confirmed_eod, "%m%d%Y")
    elsif @str_confirmed_eod =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/
      tmp = Date.strptime(@str_confirmed_eod, "%m/%d/%Y")
    else
      tmp = Date.strptime(@str_confirmed_eod, "%Y-%m-%d")
    end
    self.confirmed_eod = tmp
  end


  def denied_action_date= date
    return super(date) unless date.is_a? String
    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/
    super date
  end
  def str_denied_action_date    
    @str_denied_action_date || self.denied_action_date.to_s        
  end

  def denied_action_date_is_valid
    return if @str_denied_action_date.blank? 
    unless @str_denied_action_date =~ /^(\d{8}|\d{1,2}\/\d{1,2}\/\d{4}|\d{4}-\d{1,2}-\d{1,2})$/
      errors.add :date, 'invalid date format supplied, accepted forms are: YYYY-MM-DD, MMDDYYYY, and MM/DD/YYYY'
      return
    end
    if @str_denied_action_date =~ /^\d{8}$/
      tmp = Date.strptime(@str_denied_action_date, "%m%d%Y")
    elsif @str_denied_action_date =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/
      tmp = Date.strptime(@str_denied_action_date, "%m/%d/%Y")
    else
      tmp = Date.strptime(@str_denied_action_date, "%Y-%m-%d")
    end
    self.denied_action_date = tmp
  end


  def incoming_action_date= date
    return super(date) unless date.is_a? String
    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/
    super date
  end
  def str_incoming_action_date    
    @str_incoming_action_date || self.incoming_action_date.to_s        
  end

  def incoming_action_date_is_valid
    return if @str_incoming_action_date.blank? 
    unless @str_incoming_action_date =~ /^(\d{8}|\d{1,2}\/\d{1,2}\/\d{4}|\d{4}-\d{1,2}-\d{1,2})$/
      errors.add :date, 'invalid date format supplied, accepted forms are: YYYY-MM-DD, MMDDYYYY, and MM/DD/YYYY'
      return
    end
    if @str_incoming_action_date =~ /^\d{8}$/
      tmp = Date.strptime(@str_incoming_action_date, "%m%d%Y")
    elsif @str_incoming_action_date =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/
      tmp = Date.strptime(@str_incoming_action_date, "%m/%d/%Y")
    else
      tmp = Date.strptime(@str_incoming_action_date, "%Y-%m-%d")
    end
    self.incoming_action_date = tmp
  end


  def pipeline_action_date= date
    return super(date) unless date.is_a? String
    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/
    super date
  end
  def str_pipeline_action_date    
    @str_pipeline_action_date || self.pipeline_action_date.to_s        
  end

  def pipeline_action_date_is_valid
    return if @str_pipeline_action_date.blank? 
    unless @str_pipeline_action_date =~ /^(\d{8}|\d{1,2}\/\d{1,2}\/\d{4}|\d{4}-\d{1,2}-\d{1,2})$/
      errors.add :date, 'invalid date format supplied, accepted forms are: YYYY-MM-DD, MMDDYYYY, and MM/DD/YYYY'
      return
    end
    if @str_pipeline_action_date =~ /^\d{8}$/
      tmp = Date.strptime(@str_pipeline_action_date, "%m%d%Y")
    elsif @str_pipeline_action_date =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/
      tmp = Date.strptime(@str_pipeline_action_date, "%m/%d/%Y")
    else
      tmp = Date.strptime(@str_pipeline_action_date, "%Y-%m-%d")
    end
    self.pipeline_action_date = tmp
  end


  def sent_start_date= date
    return super(date) unless date.is_a? String
    date = Date.strptime(date, "%m%d%Y") if date =~ /\d{8}/
    date = Date.strptime(date, "%m/%d/%Y") if date =~ /\d{1,2}\/\d{1,2}\/\d{4}/
    date = Date.parse(date) if date =~ /\d{4}-\d{1,2}-\d{1,2}/
    super date
  end
  def str_sent_start_date    
    @str_sent_start_date || self.sent_start_date.to_s        
  end

  def sent_start_date_is_valid
    return if @str_sent_start_date.blank? 
    unless @str_sent_start_date =~ /^(\d{8}|\d{1,2}\/\d{1,2}\/\d{4}|\d{4}-\d{1,2}-\d{1,2})$/
      errors.add :date, 'invalid date format supplied, accepted forms are: YYYY-MM-DD, MMDDYYYY, and MM/DD/YYYY'
      return
    end
    if @str_sent_start_date =~ /^\d{8}$/
      tmp = Date.strptime(@str_sent_start_date, "%m%d%Y")
    elsif @str_sent_start_date =~ /^\d{1,2}\/\d{1,2}\/\d{4}$/
      tmp = Date.strptime(@str_sent_start_date, "%m/%d/%Y")
    else
      tmp = Date.strptime(@str_sent_start_date, "%Y-%m-%d")
    end
    self.sent_start_date = tmp
  end
end
