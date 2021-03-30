import React from 'react'
import { Helmet } from 'react-helmet'

/**
 * Main layout component
 *
 * The Layout component wraps around each page and template.
 * It also provides the header, footer as well as the main
 * styles, and meta data for each page.
 *
 */
const HomeLayout = ({ children }) => {
  return (
    <>
      <Helmet>
        <link href="/style.css" rel="stylesheet" />
        <link href="/mq.css" rel="stylesheet" />
      </Helmet>
      {children}
    </>
  )
}

export default HomeLayout
