# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
PetApplication.destroy_all
Application.destroy_all
Pet.destroy_all
Shelter.destroy_all
Veterinarian.destroy_all
VeterinaryOffice.destroy_all


vet_office_1 = VeterinaryOffice.create(name: 'Best Vets', boarding_services: true, max_patient_capacity: 27)
vet_office_2 = VeterinaryOffice.create(name: 'Vets R Us', boarding_services: true, max_patient_capacity: 20)
not_on_call_vet = vet_office_1.veterinarians.create(name: 'Sam', review_rating: 10, on_call: false)
vet_1 = vet_office_1.veterinarians.create(name: 'Taylor', review_rating: 10, on_call: true)
vet_2 = vet_office_1.veterinarians.create(name: 'Jim', review_rating: 8, on_call: true)
vet_3 = vet_office_2.veterinarians.create(name: 'Sarah', review_rating: 9, on_call: true)
vet_4 = vet_office_2.veterinarians.create(name: 'Janet', review_rating: 6, on_call: true)


shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

pet_1 = shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
pet_2 = shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
pet_3 = shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
pet_4 = shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
pet_5 = shelter_3.pets.create(name: 'Liz Ard', breed: "Jackson's chameleon", age: 7, adoptable: true)


app_1 = pet_5.applications.create!(name: 'Ms. Frizzle', address: '1 Magic Schoolbus Rd, Walkerville, MD, 01010', description: 'Because I am a boss.', status: :in_progress)
app_2 = pet_2.applications.create!(name: 'Maude', address: '2 Sunflower Rd, Hillsborough, CA, 02220', description: "My head is in the stars...", status: :pending)

pet_3.applications << app_1
