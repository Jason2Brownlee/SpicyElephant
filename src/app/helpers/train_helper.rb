module TrainHelper
  
  
  # estimate the time required to complete a number of cards
  def estimated_time_to_study(num_cards)
    return '&ndash;' if num_cards.nil?
    
    # load, read, show, answer
    time_per_card = 4
    est = time_per_card * num_cards
  
    distance_in_minutes = ((est.abs)/60).round
    distance_in_seconds = (est.abs).round
    minutes_remainder = (distance_in_seconds - (distance_in_minutes*60))

    case distance_in_minutes
      # seconds
      when 0   then time = "#{pluralize(distance_in_seconds, 'second')}"
      # minutes
      when 1..59  then time = (minutes_remainder>0) ? "#{pluralize(distance_in_minutes, 'minute')}, #{pluralize(minutes_remainder, 'second')}" : "#{pluralize(distance_in_minutes, 'minute')}"
      # hours - just clip at a hour
      else time = '>1 hour;'
    end
    
    return time
  end
  
  
end
