module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject

    # Added: Enforce presence of success and errors fields
    #========================================================
    field :success, Boolean, null: false, description: 'Flag indicating if the mutation was performed'
    field :errors, [Types::MutationErrorType], null: false, description: 'List of errors (if any) that occurred during the mutation'

    #========================================================
    # Added: Default authorization logic
    #========================================================
    def authorized?(**args)
      super

      # You may want to at least enforce that a user is logged in
      #
      # Note that we use a custom error when the user is not authenticated instead
      # of - for instance - Pundit::NotAuthorizedError.
      #
      # It is usually a good idea to return 401 (unauthorized) when the user is 
      # not authenticated and 403 (forbidden) when the user is not authorized.
      # This helps consumers (e.g. your JS frontend) decide whether it should
      # display an error or trigger a relogin for the user.
      #
      # super &&
      #   (
      #     context[:current_user] ||
      #     raise(Errors::NotAuthenticated)
      #   )
    end

    #========================================================
    # Added: Error formatting helpers
    #========================================================

    # Format ActiveRecord errors into a [Types::MutationErrorType] array
    def format_errors(record)
      unless record
        # Types::MutationErrorType object
        return [{
          path: ['record'],
          message: 'record was not found',
          code: :not_found
        }]
      end

      # Generate a list of errors with attribute, code and message
      # E.g.
      # [
      #   { attribute: 'pages', code: 'pages-blank', message: "pages can't be blank"}, 
      #   { attribute: 'pages', code: 'pages-not-a-number', message: 'pages is not a number' }
      # ]
      error_list = record.errors.keys.map do |a|
        [record.errors.details[a].map { |e| e[:error] }, record.errors[a]]
          .transpose
          .map do |e|
            {
              attribute: a.to_s.camelize(:lower),
              code: format_error_code(a, e[0]),
              message: [a.to_s, e[1]].join(' ')
            }
          end
      end.flatten

      # Generate error objects
      error_list.map do |error|
        # This is the GraphQL argument which corresponds to the validation error:
        path = ['attributes', error[:attribute]]

        # Types::MutationErrorType object
        {
          path: path,
          message: error[:message],
          code: error[:code]
        }
      end
    end

    #
    # Generate an error code from a rails validation errors
    #
    # @param [String] attribute The errored attribute
    #
    # @param [Hash] error The error object
    #
    # @return [String] The generated code
    #
    def format_error_code(attribute, error)
      [attribute, error].join(' ').dasherize.parameterize
    end
  end
end

