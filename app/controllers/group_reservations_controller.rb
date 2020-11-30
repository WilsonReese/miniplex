class GroupReservationsController < ApplicationController
  def index
    matching_group_reservations = GroupReservation.all

    @list_of_group_reservations = matching_group_reservations.order({ :created_at => :desc })

    render({ :template => "group_reservations/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_group_reservations = GroupReservation.where({ :id => the_id })

    @the_group_reservation = matching_group_reservations.at(0)

    render({ :template => "group_reservations/show.html.erb" })
  end

  def create
    #future coding changes: Theater.where({ :location_id => 1 }) <--- 1 needs to be changed to user_location


    the_group_reservation = GroupReservation.new
    #status defaults to requested, not a user input
    the_group_reservation.reservation_status = "requested"

    #chosen by user
    res_target_date = params.fetch("query_reservation_date").to_date
    res_target_time = params.fetch("query_reservation_time").to_time
    res_target_size = params.fetch("query_number_of_tickets").to_i
    
    # movie needs to come from the previous click
    res_target_movie_id = params.fetch("query_movie_id")
  
    # movie duration
    movie_duration = Movie.where({ :id => res_target_movie_id }).first.duration

    #convert res date and time into a DateTime
    d = res_target_date
    t = res_target_time
    new_reservation_datetime = DateTime.new(d.year, d.month, d.day, t.hour, t.min, t.sec)
    new_reservation_movie_end = new_reservation_datetime + movie_duration.minutes
    current_date = Date.today
    ct = Time.now.in_time_zone("Central Time (US & Canada)")
    current_datetime = DateTime.new(current_date.year, current_date.month, current_date.day, ct.hour, ct.min, ct.sec)
    
    #need to remove this
    new_res_duration = movie_duration
    the_group_reservation.number_of_tickets = res_target_size
    the_group_reservation.reservation_date = res_target_date
    the_group_reservation.reservation_duration = new_res_duration
    the_group_reservation.reservation_end_time = res_target_time + new_res_duration.minutes
    the_group_reservation.reservation_time = res_target_time
    open_time = Location.where({ :id => 1 }).first.open_time
    close_time = Location.where({ :id => 1 }).first.close_time 

    if new_reservation_datetime > current_datetime # if reservation is in the future
      if open_time > the_group_reservation.reservation_time # res too early (before opening)
        the_group_reservation.reservation_status = "failed"
        error_message = "A reservation must be between #{(open_time + 6.hours).strftime("%l:%M %p")} and #{(close_time + 6.hours).strftime("%l:%M %p")}."
      elsif close_time < the_group_reservation.reservation_end_time #  or too late, currently not used, and working improperly
        the_group_reservation.reservation_status = "failed"
        error_message = "A reservation must be between #{(open_time + 6.hours).strftime("%l:%M %p")} and #{(close_time + 6.hours).strftime("%l:%M %p")}."
      else
      
        a_theater_position = 0 # starting array position
        theaters_unavailable = 0
        theaters_too_small = 0
        while the_group_reservation.reservation_status == "requested" # reservation is not available

          # i think there is a way to make methods in theater.rb called available and big_enough => if a_theater.available and if a_theater.big_enough
          if Theater.where({ :location_id => 1 }).at(a_theater_position) == nil # if we have already checked all the theaters
            the_group_reservation.reservation_status = "failed" # break while loop
          else # we have not checked all theaters and need to go through it again
            a_theater = Theater.where({ :location_id => 1 }).at(a_theater_position) # get a theater in array of theaters

            if res_target_size <= a_theater.seats_in_theater # if theater is big enough
              # check if there are reservations on a day
              if a_theater.group_reservations.where({ :reservation_date => res_target_date }).count == 0 # no reservations
                the_group_reservation.reservation_status = "available"
                new_res_duration = movie_duration + a_theater.turnover_time
                new_res_theater = a_theater.id
                
              elsif a_theater.group_reservations.where({ :reservation_date => res_target_date }).count > 0
                the_group_reservation.reservation_duration = movie_duration + a_theater.turnover_time
                a_theater.group_reservations.where({ :reservation_date => res_target_date }).each do |a_reservation|
                  if the_group_reservation.overlaps?(a_reservation) # if it overlaps
                    
                    theaters_unavailable += 1

                    # then make it redirect to the same reservation page, with an error message and a slightly earlier and later start times suggestions
                    # when suggesting new times, we only want to look in theaters that are big enough
                    # make a suggested start time that equal target_time, it should automatically update target_end_time (start time+ duration)
                    # check each minute earlier and later in a theater if it overlaps to get earlier time and later time
                    

                  else # does not overlap
                    the_group_reservation.reservation_status = "available"
                    new_res_duration = movie_duration + a_theater.turnover_time
                    new_res_theater = a_theater.id
                  end 
                end
              end

            else # theater is not big enough
              # check next theater
              theaters_too_small += 1
              
            end
          end

          a_theater_position += 1 #move to next position in array

        end

        count_of_theaters = Theater.where({ :location_id => 1 }).count
        if theaters_unavailable + theaters_too_small == count_of_theaters # if all theaters fail for some reason
          if theaters_unavailable != count_of_theaters # if some theaters were too small
            error_message = "There are no theaters available that seat #{res_target_size.to_s} people at #{res_target_time.strftime("%l:%M %p")}."
          else # the only reason a res failed is because times were blocked off, not group size
            error_message = "There are no theaters available at #{res_target_time.strftime("%l:%M %p")}."
          end

          # #suggest new times
          # # need to check each theater
          # # suggested times does not work!! might be that overlaps doesn't work <- check in console
          # @best_earlier_time = Time.new
          # @best_later_time = Time.new
          # Theater.where({ :location_id => 1 }).each do |a_theater|
          #   if res_target_size <= a_theater.seats_in_theater # if theater is big enough
          #     the_group_reservation.reservation_duration = movie_duration + a_theater.turnover_time

          #     a_theater.group_reservations.where({ :reservation_date => res_target_date }).each do |a_reservation| #check each reservation
          #       while the_group_reservation.overlaps?(a_reservation)
          #         the_group_reservation.reservation_time = the_group_reservation.reservation_time - 1.minutes
          #       end
          #       earlier_time = the_group_reservation.reservation_time
          #       if (res_target_time - @best_earlier_time) > (res_target_time - earlier_time)
          #         @best_earlier_time = earlier_time
          #       end 
          #       the_group_reservation.reservation_time = res_target_time

                
          #       while the_group_reservation.overlaps?(a_reservation) # while it overlaps add a minute until it overlaps
          #         the_group_reservation.reservation_time = the_group_reservation.reservation_time + 1.minutes
          #       end
          #       later_time = the_group_reservation.reservation_time
          #       if (res_target_time - @best_later_time).abs > (res_target_time - later_time).abs
          #         @best_later_time = later_time
          #       end 
                
          #       the_group_reservation.reservation_time = res_target_time

                
          #       # if the_group_reservation.reservation_time < a_reservation.reservation_time #if the time starts before
          #       #   while the_group_reservation.overlaps?(a_reservation)
          #       #     the_group_reservation.reservation_time = the_group_reservation.reservation_time - 1.minutes
          #       #   end
          #       #   earlier_time = the_group_reservation.reservation_time
          #       #   the_group_reservation.reservation_time = res_target_time
          #       # elsif the_group_reservation.reservation_time > a_reservation.reservation_time # if the time starts after
          #       #   while the_group_reservation.overlaps?(a_reservation) # while it overlaps add a minute until it overlaps
          #       #     the_group_reservation.reservation_time = the_group_reservation.reservation_time + 1.minutes
          #       # end
          #     end

          #   end
          # end
          # error_message = error_message + "Available earlier: #{@best_earlier_time} Available later: #{@best_later_time}"

          # # While overlaps?(), subtract/add one minute from start time.
          # # Save as earlier/later start time if it is closer to target time
          # # Check each theater and if then I’ll get the best available earlier and later times. 
          # # *need to account for theater size and date as well
          # # Then I need to check which one is closest to target time. Suggest both, but prepopulate with the closer time, 
          # # They then check availability again (maybe rename that button)


        end
      end

    else
      the_group_reservation.reservation_status = "failed"
      error_message = "A reservation must be in the future."
    end

    if the_group_reservation.reservation_status == "available"
      the_group_reservation.number_of_tickets = res_target_size
      the_group_reservation.reservation_date = res_target_date
      the_group_reservation.reservation_duration = new_res_duration
      the_group_reservation.reservation_end_time = res_target_time + new_res_duration.minutes

      the_group_reservation.reservation_time = res_target_time
      the_group_reservation.theater_id = new_res_theater
      the_group_reservation.movie_id = res_target_movie_id
      
      if the_group_reservation.valid?
        the_group_reservation.save
        redirect_to("/group_reservations/#{the_group_reservation.id}", { :notice => "Group reservation created successfully." })
      else
        redirect_to("/group_reservations", { :notice => "Group reservation failed to create successfully." })
      end
    elsif the_group_reservation.reservation_status == "failed"
      redirect_to("/group_reservations", { :alert => error_message })
    else
      redirect_to("/group_reservations", { :notice => "I messed something up" })
    end
    
    
  end

  def update
    the_id = params.fetch("path_id")
    the_group_reservation = GroupReservation.where({ :id => the_id }).at(0)

    the_group_reservation.reservation_status = params.fetch("query_reservation_status")
    the_group_reservation.reservation_date = params.fetch("query_reservation_date")
    the_group_reservation.reservation_time = params.fetch("query_reservation_time")
    the_group_reservation.reservation_duration = params.fetch("query_reservation_duration")
    the_group_reservation.number_of_tickets = params.fetch("query_number_of_tickets")
    the_group_reservation.movie_id = params.fetch("query_movie_id")
    the_group_reservation.theater_id = params.fetch("query_theater_id")

    if the_group_reservation.valid?
      the_group_reservation.save
      redirect_to("/group_reservations/#{the_group_reservation.id}", { :notice => "Group reservation updated successfully."} )
    else
      redirect_to("/group_reservations/#{the_group_reservation.id}", { :alert => "Group reservation failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_group_reservation = GroupReservation.where({ :id => the_id }).at(0)

    the_group_reservation.destroy

    redirect_to("/group_reservations", { :notice => "Group reservation deleted successfully."} )
  end
end
