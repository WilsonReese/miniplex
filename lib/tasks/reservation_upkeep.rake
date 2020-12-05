# if a reservation has been created for 5 minutes, but still has not been confirmed it should destroy the reservation

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

# if a confirmed reservation has passed, it needs to be listed as complete
task({ :complete_reservations => :environment }) do
  GroupReservation.all.each do |a_res|
    if a_res.reservation_status == "confirmed" # confirmed
      d = a_res.reservation_date
      t = a_res.reservation_end_time
      res_datetime = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec)
      if (DateTime.now - 6.hours) > res_datetime
        a_res.reservation_status = "complete"
        a_res.save
      end
    end
  end 
end 

task({ :delete_all_reservations => :environment }) do
  GroupReservation.destroy_all
end