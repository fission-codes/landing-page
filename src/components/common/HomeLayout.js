import React from 'react'
// Styles
import '../../styles/style.css'
import '../../styles/mq.css'

/**
 * Main layout component
 *
 * The Layout component wraps around each page and template.
 * It also provides the header, footer as well as the main
 * styles, and meta data for each page.
 *
 */
const HomeLayout = ({ children }) => {
  return <>{children}</>
}

export default HomeLayout
