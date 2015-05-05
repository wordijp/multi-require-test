
$ = require('jquery')
_ = require('underscore')
Enumerable = require('linq')

students = [
  {name: 'wordi', height: 172, power: 20}
  {name: 'tarou', height: 168, power: 23}
  {name: 'legend of kobayashi', height: 155, power: 999}
  {name: 'aniki', height: 162, power: 523}
  {name: 'hideo', height: 180, power: 3}
]

# g’·‡‚ÅŽOˆÊ‚Ü‚Å•\Ž¦
students = _.sortBy(students, (x) -> -x.height)
Enumerable.from(students)
  .take(3)
  .forEach((x, i) ->
    rank = i + 1
    $('#ranking').append("""
      <li>
        <h#{rank}>
          #{rank} : name:#{x.name} height:#{x.height} power:#{x.power}
        </h#{rank}>
      </li>
    """)
  )


