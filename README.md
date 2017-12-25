# Amazon Practice Project

* Products
  (belongs to user)
  (has many reviews)
  - create new products
  - display single product/ list of products
  - edit products
  - delete products

* Reviews
  (belongs to product)
  (belongs to user)
  - create, display, delete reviews

* Users
  (has many products)
  (has many reviews)
  - admin
  - authentication
  - authorization (can only edit and delete their own creation)
  - add account management page (user can change its info)

* Others
  - home page (Add full-page background but need to fix flash message) <<
  - about page
  - contact us page (not functional. add required attribute to 2 tags) <<
  - add search product function

* styling
  - bootstrap4 - all forms
  - add font-awesome gem for icons
  - add kaminari gem for pagination (pending)

* special notes:
  - in config/application.rb add:
  ```
      config.action_view.field_error_proc = Proc.new { |html_tag, instance|
        html_tag
      }
  ```
