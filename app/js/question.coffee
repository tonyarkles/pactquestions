
window.A =
  Views: {}
  Instances: {}

window.questions =
  landing:
    Yes: 'page1'
    No: 'page2'
  page1:
    'Less than 10': 'less-than-10'
    '10 to 20': '10-to-20'
    'More than 20': 'more-than-20'
  page2: {}
  'less-than-10': {}
  '10-to-20': {}
  'more-than-20': {}

class A.Views.Question extends Backbone.View
  template: 'app/templates/question.us'
  buttonTemplate: 'app/templates/question-button.us'
  initialize: () ->
    @currentQuestion = ""
    @render()

  render: () =>
    console.log 'Rendered question'
    q = window.questions[@currentQuestion]
    if q
      @$el.html( window.JST[@template]() )
      @$el.find('.question-body').html( window.JST["app/templates/question/#{@currentQuestion}.us"]() )
      bg = @$el.find('.question-buttons')
      _.each(q, (question, title) =>
        bg.append(window.JST[@buttonTemplate](title: title, hash: question))
      )
    @

  setQuestion: (question) ->
    @currentQuestion = question
    @render()
    
class A.Router extends Backbone.Router
  routes:
    'landing': 'landing'
    'q/:question': 'question'
    '*path': 'landing'

  ensureQuestionView: () ->
    if !@questionView
      @questionView = new A.Views.Question(el: $('.question-panel'))
            
  landing: () ->
    @ensureQuestionView()
    @questionView.setQuestion('landing')
    
  question: (question) ->
    @ensureQuestionView()
    @questionView.setQuestion(question)

$ () ->
  window.router = new A.Router()
  Backbone.history.start()