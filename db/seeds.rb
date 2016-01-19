# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Season.create([{ name: "Vorfrühling" },
               { name: "Erstfrühling" },
               { name: "Vollfrühling" },
               { name: "Frühsommer" },
               { name: "Hochsommer" },
               { name: "Spätsommer" },
               { name: "Frühherbst" },
               { name: "Vollherbst" },
               { name: "Spätherbst" },
               { name: "Winter" }
             ])
