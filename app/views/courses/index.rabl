collection @courses
attributes :id, :title, :number

child(:subject) { attributes :code, :description }
#node(:read) { |post| post.read_by?(@user) }
