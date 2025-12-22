# Create quiz categories for both languages

puts "Creating quiz categories..."

# Vietnamese categories
vi_categories = [
  { name: "Hình học", description: "Các câu hỏi về đối xứng trong hình học", language: :vi },
  { name: "Hình mỹ thuật", description: "Các câu hỏi về đối xứng trong nghệ thuật và thiết kế", language: :vi },
  { name: "Hình thực tế", description: "Các câu hỏi về đối xứng trong đời sống thực tế", language: :vi }
]

# English categories
en_categories = [
  { name: "Geometry", description: "Questions about symmetry in geometry", language: :en },
  { name: "Art & Design", description: "Questions about symmetry in art and design", language: :en },
  { name: "Real World", description: "Questions about symmetry in everyday life", language: :en }
]

(vi_categories + en_categories).each do |category_attrs|
  category = QuizCategory.find_or_initialize_by(name: category_attrs[:name], language: category_attrs[:language])
  category.assign_attributes(category_attrs)
  category.save!
  puts "  ✓ #{category.language.upcase}: #{category.name}"
end

puts "Quiz categories created!"

