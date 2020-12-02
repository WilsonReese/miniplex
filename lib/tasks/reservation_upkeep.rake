
task({ :clear_unconfirmed_reservations => :environment }) do
  GroupReservation.all.each do |a_res|
    # has a reservation been created for more than five minutes but still have an available status?
    if Time.now > a_res.created_at + 5.minutes
      if a_res.reservation_status == "available"
        a_res.destroy
      end
    end
  end
end

# has a reservation passed? Day is same or after res day
  # GroupReservation.all.each do |a_res|
  #   if a_ 
  #   if Date.today >= a_res.reservation_date
  #     if (Time.now - 6.hours).strftime("%l:%M %p") >