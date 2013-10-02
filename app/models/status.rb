class Status < ActiveRecord::Base
  ACCESSORS = ['courses_tally', 'people_tally', 'last_banner_import', 'last_iam_import']
  
  def self.method_missing(method, *args, &block)
    if (ACCESSORS.include? method.to_s) or (ACCESSORS.map{ |a| a + "=" }.include? method.to_s)
      if args.length == 1
        # Setter
        key = method[0..-2] # remove the '='
        s = Status.find_or_create_by_key(key)
        s.value = args[0]
        s.save!
        return
      else
        # Getter
        key = method
        return Status.find_or_create_by_key(key).value
      end
    else
      super
    end
  end
end
