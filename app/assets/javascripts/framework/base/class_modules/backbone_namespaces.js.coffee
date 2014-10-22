@BackboneNamespacesModule =

  extended: (klass) ->
    Object.merge klass,
      Behaviors: {}
      Collections: {}
      Models: {}
      ViewModels: {}
      Views: {}
      Utils: {}

