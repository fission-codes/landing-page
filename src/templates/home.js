import PropTypes from 'prop-types'
import React from 'react'
import { Layout } from '../components/common'
import { MetaData } from '../components/common/meta'

/**
 *
 * Landing Page
 *
 */
const Home = ({ location }) => {
  return (
    <>
      <MetaData location={location} />
      <Layout isHome={true}>
        <div className="container">
          Landing Page w00t
          <p>
            Check out the <a href="/blog/">blog</a>!
          </p>
        </div>
      </Layout>
    </>
  )
}

export default Home
