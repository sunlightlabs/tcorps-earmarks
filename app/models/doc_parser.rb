class DocParser
  
  P_AMOUNT                 = '(?<amount>[$]?[\d,]+(.\d\d)?)'
  P_PROJECT_TITLE          = '(?<project_title>.+)'
  P_FISCAL_YEAR            = '(?<fiscal_year>[\d]{4})'
  P_ENTITY_NAME            = '(?<entity_name>.+[^,])'
  P_ENTITY_ADDRESS         = '(?<entity_address>.+)'
  P_FUNDING_PURPOSE        = '(?<funding_purpose>The funding would be used .+)'
  P_TAXPAYER_JUSTIFICATION = '(?<taxpayer_justification>.+)'
  
  P1 = 'I am requesting ' + P_AMOUNT + ' ' +
    'for (the )?' + P_PROJECT_TITLE + ' ' +
    'in fiscal year ' + P_FISCAL_YEAR + '\. ' +
    'The entity to receive funding for this project is (the )?' + P_ENTITY_NAME + '(,)? ' + 
    'located at ' + P_ENTITY_ADDRESS + '\. ' +
    P_FUNDING_PURPOSE + ' ' + 
    'Taxpayer Justification: ' + P_TAXPAYER_JUSTIFICATION + ' ' +
    'I certify that neither I nor my spouse has any direct financial ' +
    'interest in this project.'

  P2 = 'I am requesting ' + P_AMOUNT + ' ' +
    'for (the )?' + P_PROJECT_TITLE + ' ' +
    'in fiscal year ' + P_FISCAL_YEAR + '\. ' +
    'The entity to receive funding for this project is (the )?' + P_ENTITY_NAME + '(,)? ' + 
    'located at ' + P_ENTITY_ADDRESS + '\. ' +
    P_FUNDING_PURPOSE
  
  P3 = 'I am requesting ' + P_AMOUNT + ' ' +
    'for (the )?' + P_PROJECT_TITLE + ' ' +
    'in fiscal year ' + P_FISCAL_YEAR + '\. ' +
    'The entity to receive funding for this project is (the )?' + P_ENTITY_NAME + '(,)? ' + 
    'located at ' + P_ENTITY_ADDRESS + '\. '
    
  P4 = 'I am requesting ' + P_AMOUNT + ' ' +
    'for (the )?' + P_PROJECT_TITLE + ' ' +
    'in fiscal year ' + P_FISCAL_YEAR
  
  P5 = 'I am requesting ' + P_AMOUNT + ' ' +
    'for (the )?' + P_PROJECT_TITLE + ' '
  
  P6 = 'I am requesting ' + P_AMOUNT
  
  PATTERNS = [P1, P2, P3, P4, P5, P6]
  
  def self.compile_patterns
    @compiled_patterns ||= PATTERNS.map do |pattern|
      Oniguruma::ORegexp.new(pattern)
    end
  end

  def self.matches(source)
    compile_patterns.map do |reg_exp|
      reg_exp.match(source)
    end
  end
  
  def self.best_match(source)
    matches(source).each do |match|
      if match
        return match
      end
    end
    nil
  end

end
