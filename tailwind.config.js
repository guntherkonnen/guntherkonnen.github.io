// const plugin = require('tailwindcss/plugin')

// module.exports = {
//   plugins: [
//     plugin(function({ addVariant }) {
//       addVariant('hocus', ['&:hover', '&:focus'])
//     })
//   ]
// }


module.exports = {
  content: ["./source/**/*.html.erb"],

  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/line-clamp'),
    require('@tailwindcss/aspect-ratio'),
  ]
}
