# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

packages = Package.create([{ name: "SwaasthyaM", content: "A basic detoxification programme through Ayurveda, which includes Abhyanga, Svedana, and Vasti or Virechana.

  It also includes practice of Asanas and Pranayama, and theory of Yoga and Ayurveda, to make it a deeply-immersive first-hand experience of Ayurveda for the care-seekers.
  ", cost: 45000, duration: 10, eligibility: "-> Anyone between 18 and 65 years of age, with no major ailments or chronic diseases, may participate.
  -> Care-seekers will be requested to do some basic tests. Participation is subject to the approval of the panel of doctors.", note: "-> Treatment won’t be administered to women on their special days.
    -> This is not a treatment for any illness, but a therapeutic programme."},{ name: "ShantaM - Peace and Calm", content: "Ayurvedic treatment will include
  -> Abhyangam
  -> Shirodhara
  -> Pada Seva
  -> Thalam
  
  Yogic practice of Yoga Nidra, with theory of Yoga and Ayurveda and practice of appropriate Asanas and Pranayama.
  
  Benefits of ShantaM
  
  -> Better sleep
  -> Better energy levels
  -> Improvement in appetite
  -> Better blood pressure profile
  -> Feeling of calmness and lightness in body and mind
  -> Better digestion
  -> Overall Improvement in health", cost: 55000, duration: 10, eligibility: "-> Anyone from 18 to 80 years of age, who feels the need to take a step back and relax, breathe easy, and calm the body and mind. That includes students, professionals, those who suffer from anxiety, and those whose lives are fast paced.", note: "-> Treatment won’t be administered to women on their special days.
  -> This is not a treatment for any illness, but a therapeutic programme." }, 
  { name: "LanghanM", content: "A 15-day residential weight management programme at ĀrogyaM. The programme includes:

    - One consultation with the physician, and one lifestyle consultation.
    
    - Abhyangam - Synchronised Ayurvedic massage involving medicated oils administered by two therapists
    
    - Svedanam - Perspiring using herbal medicated steam
    
    - Udvarthanam – A massage involving various herbal powders applied on the body in a reverse direction for better lymphatic drainage. Classically suggested for weight management and toning of the body
    
    - Snehapanam – Administration of medicated ghee in controlled doses under the supervision of an Ayurvedic physician for greater cleansing of the body
    
    - Vasti or Virechanam – Panchakarma processes of medicated enema or purging done under the supervision of an Ayurvedic physician, following Snehapanam
    
    - Yoga – M-Yoga including Asanas and Pranayama, and Yoga Nidra.
    
    ", cost: 70000, duration: 15, eligibility:  "Anyone between 18 and 75", note: "- Treatment won’t be administered to women on their special days.

    - This is not a treatment for any illness, but a therapeutic programme."}, { name: "VishraM - 3 days of rest and rejuvenation", content: "ĀrogyaM, the Wellness Centre at The Sacred Grove, offers VishraM, 3 days of rest and rejuvenation. You are welcome to experience VishraM whenever you can spare three precious days towards your well-being. The programme includes:

    - A detailed Ayurvedic consultation
    
    - Abhyanga - Synchronised Ayurvedic massage involving medicated oils administered by two therapists
    
    - Svedana - Perspiring using herbal medicated steam
    
    - Virechana - Purging using medicated castor oil
    
    - Shirodhara - A de-stress therapy where one and a half litres of medicated oil are rhythmically dropped onto the forehead, relaxing the nerves and strengthening them.
    
    - Yoga practice that includes Asanas and Pranayama.", cost: 14800, duration: 3, eligibility: "Anyone above the age of 18", note: "- Treatment won’t be administered to women on their special days.

    - This is not a treatment for any illness, but a therapeutic programme."}])