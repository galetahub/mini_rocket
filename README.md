# MiniRocket

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/mini_rocket`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mini_rocket'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mini_rocket

## Usage

Simple CRUD:

```ruby
# frozen_string_literal: true

class Manage::UsersController < Manage::BaseController
  include MiniRocket::Controller

  authorize_resource class: User

  defaults resource_class: User
  permit_params :all

  scopes do
    scope I18n.t('label.all'), default: true

    User.states.each do |key, value|
      scope(I18n.t(key, scope: 'users.states')) { |items| items.where(state: value) }
    end
  end

  filter do |f|
    f.input :name
    f.input :email
    f.input :phone_number
    f.input :city_id, collection: City.alphabetically
    f.input :role_type_id, collection: RoleType.users, label_method: :title
    f.input :drugstore_id
    f.input :with_cert, as: :boolean
  end

  index title: -> { I18n.t('menu.users') } do
    id_column
    column :name
    column :main_office do |user|
      user.drugstore.try(:main_office)
    end
    column :state do |user|
      status_tag I18n.t(user.state, scope: 'user.states'), user.state
    end
    column :address do |user|
      user.smart_address
    end
    column :balance do |user|
      user.total_balance
    end
    actions
  end

  form do |f|
    f.inputs 'Credentials' do
      input :phone_number
      input :password, input_html: { autocomplete: 'new-password' }
    end

    f.inputs 'Details' do
      input :drugstore_uuid, {
        as: :select,
        collection: Drugstore.where(id: f.object.drugstore_id).pluck(:main_office, :uuid),
        input_html: {
          class: 'ajax-select-drugstore',
          data: { 'ajax--url' => '/manage/search/drugstores' }
        }
      }

      input :role_type_id, collection: RoleType.users, label_method: :title

      input :first_name
      input :last_name
      input :email
    end

    f.actions
  end

  show do |record|
    attributes_table_for record, layout: false do
      row :id
      row :first_name
      row :last_name
      row :email
      row :phone_number
      row :state do
        status_tag I18n.t(record.state, scope: 'user.states'), record.state
      end
      row :address
      row :role_type do
        record.role_type.try(:title)
      end
      row :drugstore_uuid

      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :current_sign_in_ip
      row :last_sign_in_ip
      row :failed_attempts
      row :locked_at

      row :created_at
      row :updated_at
    end
  end

  def show
    @gifts = ::Stats::MonthlyDrugstore.with_state(:waiting)
                                      .with_certificates
                                      .where(drugstore_id: resource.drugstore_id)
                                      .recently
    super
  end

  def migrate
    user = User.find(params[:id])
    Users::MigrateCommand.call(user, params[:event])

    redirect_to manage_user_path(user), notice: I18n.t('user.actions.migrated')
  end

  protected

  def end_of_association_chain
    scope = super.includes(:drugstore).filter(params[:filter]).recently
    AdminsUsersQuery.new(scope, current_admin_user).query
  end
end
```

### Localization inputs

```ruby
form html: { multipart: true } do |f|
  f.localization do
    input :title
    input :content, as: :text
  end

  f.inputs 'Details' do
    input :is_visible, wrapper: :inline_checkbox
    input :sort_order
    input :picture, as: :uploader, hint: '300x300'
  end

  f.actions
end
```

### Specify actions you want

```ruby
form only: [:edit, :update] do |f|
  f.localization do
    input :subtitle
    input :content, as: :text
  end

  f.actions
end
```

### Index action turn off pagination

```ruby
index pagination: false do
  id_column
  column :title
  column :address
  column :is_visible
  actions
end
```

### Show action

```ruby
show do |record|
  attributes_table_for record do
    row :id
    row :title
    row :slug
    row :content do
      simple_format record.content
    end
    row :product_type
    row :sort_order
    row :is_visible
    row :created_at
    row :updated_at
  end

  table_for :tooltips, -> { record.tooltips.recently } do
    id_column
    column :title
    column :sort_order
    column :is_visible
    column :updated_at
    column :actions do |tooltip|
      render partial: 'manage/tooltips/index_actions', locals: { resource: tooltip }
    end

    bottom do
      link_to t('mini_rocket.buttons.add'), new_manage_product_tooltip_path(record), class: 'btn btn-primary'
    end
  end

  panel 'Schema' do
    render partial: '/manage/products/schema', locals: { product: record }
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mini_rocket.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
