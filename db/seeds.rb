# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

w0 = Workplace.create!(name: 'University',
                       street_name: 'Wilhemshöher Alle',
                       street_number: '73',
                       city: 'Kassel',
                       zip_code: 34121)

w1 = Workplace.create!(name: 'Home Office',
                       street_name: 'at home',
                       street_number: '0',
                       city: '0',
                       zip_code: 0)

w2 = Workplace.create!(name: 'Lager',
                       street_name: 'Lagerstraße',
                       street_number: '123',
                       city: 'Lagerstadt',
                       zip_code: 12345)

w3 = Workplace.create!(name: 'Office',
                       street_name: 'straße',
                       street_number: '123',
                       city: 'Arbeiterstadt',
                       zip_code: 12345)

u0 = User.create!(firstname: 'Maurice',
                  lastname: 'Herwig',
                  password: 'password',
                  email: 'maurice.herwig@uni-kassel.de',
                  monthly_hours: 80,
                  is_admin: true,
                  workplace: Workplace.find(w1.id),
                  personal_secret: 'bye')

u1 = User.create!(firstname: 'test',
                  lastname: 'Malocher',
                  password: 'password',
                  email: 'test@uni-kassel.de',
                  monthly_hours: 160,
                  is_admin: false,
                  workplace: Workplace.find(w0.id),
                  personal_secret: 'bye')
for user in [u0, u1]
  for i in 0..13 do
    month = (i % 12) + 1
    year = 2022 + (i / 12).to_i

    m0 = MonthlyWork.create!(month: month,
                             year: year,
                             user: User.find(user.id))

    for day in 1..28 do
      start_hour = rand(5..13)
      start_min = rand(0..59)

      end_hour = start_hour + rand(0..9)
      end_min = rand(0..59)

      if (end_hour == start_hour) && end_min < start_min
        start_min = rand(0..58)
        end_min = rand(start_min..59)
      end

      start_time = Time.new(year, month, day, start_hour, start_min, 0)
      end_time = Time.new(year, month, day, end_hour, end_min, 0)

      if ((end_time - start_time) / 1.minute).round > 480
        striking = true
      else
        striking = false
      end

      workplace = [w0, w0, w0, w1, w2, w3].shuffle.first

      wp = WorkTime.create!(start_time: start_time,
                            end_time: end_time,
                            striking: striking,
                            monthly_work: MonthlyWork.find(m0.id),
                            workplace: Workplace.find(workplace.id))

      if striking
        Comment.create!(comment: 'Sorry ich wollte mal wieder nicht nach hause',
                        user: User.find(user.id),
                        work_time: WorkTime.find(wp.id))

      end
    end
  end
end
