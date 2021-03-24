import React from 'react'
import { MetaData } from '../components/common/meta'
import { HomeLayout } from '../components/common'

/**
 *
 * Landing Page
 *
 */
const Home = ({ location }) => {
  return (
    <>
      <MetaData location={location} />
      <HomeLayout>
        <div className="container">
          <main>
            <nav>
              <div className="module12 std">
                <div className="col6 P4">Logo</div>
                <ul className="col6 flex centeralign P4 desktop">
                  <li>
                    <a href="#process">Process</a>
                  </li>
                  <li>
                    <a href="#features">Features</a>
                  </li>
                  <li>
                    <a href="#community">Community</a>
                  </li>
                  <li>
                    <a href>Documentation</a>
                  </li>
                </ul>
                <div
                  className="col6 right hamburger mobile"
                  style={{ padding: '6rem' }}
                >
                  =
                </div>
              </div>
            </nav>
            <section className="frame">
              <div className="module12 std">
                <div className="col6 bottomalign mcenter">
                  <span style={{ marginBottom: '6rem' }}>
                    <h1>
                      {' '}
                      Weightless SDK <br />
                      for App Freedom{' '}
                    </h1>
                    <p>
                      Create and publish your own webnative apps using Elm, Vue
                      or React. Enjoy user accounts, encrypted storage and
                      managed hosting with zero backend configuration.
                    </p>
                  </span>
                  <span>
                    <button className="buttonmain">
                      <span className="buttontext">Try Fission</span>
                      <span className="buttonicon">
                        <img src="/assets/icon-1.png" width="100%" />
                      </span>
                    </button>
                    <button className="buttonlink">
                      <span className="buttontext">Watch Demo</span>
                      <span className="buttonicon">
                        <img src="/assets/icon-2.png" width="100%" />
                      </span>
                    </button>
                  </span>
                </div>
                <div className="col6">
                  <figure>
                    <img
                      alt="Video Media"
                      src="/assets/VideoMedia.png"
                      width="100%"
                    />
                  </figure>
                </div>
              </div>
            </section>
            <div id="process" className="grad">
              <section className="frame" style={{ paddingTop: 0 }}>
                <div className="module12 std">
                  <div className="col6 bottomalign mcenter">
                    <h1>
                      {' '}
                      Fission Empowers Creators <br />
                      to Do What They Love.{' '}
                    </h1>
                    <span style={{ paddingBottom: '8rem' }} />
                    <button className="buttonmain">
                      <span className="buttontext">Get Started</span>
                      <span className="buttonicon">
                        <img src="/assets/icon-1.png" width="100%" />
                      </span>
                    </button>
                  </div>
                  <div className="col6">
                    <figure>
                      <img
                        alt="Space Dandies"
                        src="/assets/SpaceDandies.png"
                        width="100%"
                      />
                    </figure>
                  </div>
                </div>
              </section>
            </div>
            <section className="frame" style={{ paddingTop: 0 }}>
              <div className="module5 std">
                <span className="col5 line" />
                <div className="col1 mcenter">
                  <h3 className="subheader">1. Envision</h3>
                  <p style={{ paddingTop: '0rem' }}>
                    Focus on developing your next big (or small) web app idea,
                    and not thinking about which tech stack to choose.
                  </p>
                </div>
                <div className="col1 mcenter">
                  <h3 className="subheader">2. Build</h3>
                  <p style={{ paddingTop: '0rem' }}>
                    Solo app-making is not just for full-stack developers
                    anymore. With Fission, anyone who is familiar with Elm, Vue
                    or React can build anything they can imagine.
                  </p>
                </div>
                <div className="col1 mcenter">
                  <h3 className="subheader">3. Stack</h3>
                  <p style={{ paddingTop: '0rem' }}>
                    Integrate your frontend with Fission’s webnative SDK to get
                    everything from user authentication to encrypted file
                    storage.
                  </p>
                </div>
                <div className="col1 mcenter">
                  <h3 className="subheader">4. Publish</h3>
                  <p style={{ paddingTop: '0rem' }}>
                    Invite beta users early on and make your app available to
                    everyone as soon as it’s done — no new deployment
                    techniques to learn.
                  </p>
                </div>
                <div className="col1 mcenter">
                  <h3 className="subheader">5. Sell</h3>
                  <p style={{ paddingTop: '0rem' }}>
                    Turn your app into a side gig or a real business. Create,
                    clone and adjust custom apps for sale, or switch to a SaaS
                    model and work on growing your own customer base.
                  </p>
                </div>
              </div>
            </section>
            <div id="features" className="bg">
              <section className="frame">
                <div className="module12 std">
                  <span className="col12 mcenter">
                    <h2 className="invert"> Platform Features </h2>
                  </span>
                  <div className="col6 mcenter">
                    <figure>
                      <img
                        alt="Video Media"
                        src="/assets/DriveRepresentation.png"
                        width="100%"
                      />
                    </figure>
                    <h3 className="subheader invert" style={{ paddingTop: 0 }}>
                      Webnative SDK
                    </h3>
                    <p className="invert" style={{ paddingTop: '0rem' }}>
                      Using cutting-edge browser features, Fission’s webnative
                      SDK lets you create a native-like app experience across
                      devices out of your frontend code, with user accounts,
                      managed hosting, passwordless logins, and more.
                    </p>
                  </div>
                  <div className="col6 mcenter">
                    <figure>
                      <img
                        alt="Video Media"
                        src="/assets/DriveRepresentation.png"
                        width="100%"
                      />
                    </figure>
                    <h3 className="subheader invert" style={{ paddingTop: 0 }}>
                      Webnative SDK
                    </h3>
                    <p className="invert" style={{ paddingTop: '0rem' }}>
                      Using cutting-edge browser features, Fission’s webnative
                      SDK lets you create a native-like app experience across
                      devices out of your frontend code, with user accounts,
                      managed hosting, passwordless logins, and more.
                    </p>
                  </div>
                </div>
              </section>
            </div>
            <div className="bg">
              <section className="frame">
                <div className="module12 std frame linegap tmodule">
                  <div className="col4 center bg">
                    <figure>
                      <img
                        alt="Video Media"
                        src="/assets/features-1.png"
                        width="80px"
                      />
                    </figure>
                    <span>
                      <h5
                        className="smalltext invert uppercase"
                        style={{ paddingTop: 0 }}
                      >
                        User Accounts
                      </h5>
                    </span>
                  </div>
                  <div className="col4 center bg">
                    <figure>
                      <img
                        alt="Video Media"
                        src="/assets/features-2.png"
                        width="80px"
                      />
                    </figure>
                    <span>
                      <h5
                        className="smalltext invert uppercase"
                        style={{ paddingTop: 0 }}
                      >
                        Passwordless Login
                      </h5>
                    </span>
                  </div>
                  <div className="col4 center bg">
                    <figure>
                      <img
                        alt="Video Media"
                        src="/assets/features-3.png"
                        width="80px"
                      />
                    </figure>
                    <span>
                      <h5
                        className="smalltext invert uppercase"
                        style={{ paddingTop: 0 }}
                      >
                        Seamless Sync
                      </h5>
                    </span>
                  </div>
                  <div className="col4 center bg">
                    <figure>
                      <img
                        alt="Video Media"
                        src="/assets/features-4.png"
                        width="80px"
                      />
                    </figure>
                    <span>
                      <h5
                        className="smalltext invert uppercase"
                        style={{ paddingTop: 0 }}
                      >
                        Encrypted Storage
                      </h5>
                    </span>
                  </div>
                  <div className="col4 center bg">
                    <figure>
                      <img
                        alt="Video Media"
                        src="/assets/features-5.png"
                        width="80px"
                      />
                    </figure>
                    <span>
                      <h5
                        className="smalltext invert uppercase"
                        style={{ paddingTop: 0 }}
                      >
                        Managed Hosting
                      </h5>
                    </span>
                  </div>
                  <div className="col4 center bg">
                    <figure>
                      <img
                        alt="Video Media"
                        src="/assets/features-6.png"
                        width="80px"
                      />
                    </figure>
                    <span>
                      <h5
                        className="smalltext invert uppercase"
                        style={{ paddingTop: 0 }}
                      >
                        SSL &amp; Subdomains
                      </h5>
                    </span>
                  </div>
                  <div className="col4 center bg">
                    <figure>
                      <img
                        alt="Video Media"
                        src="/assets/features-7.png"
                        width="80px"
                      />
                    </figure>
                    <span>
                      <h5
                        className="smalltext invert uppercase"
                        style={{ paddingTop: 0 }}
                      >
                        Build-in payments
                      </h5>
                    </span>
                  </div>
                  <div className="col4 center bg">
                    <figure>
                      <img
                        alt="Video Media"
                        src="/assets/features-8.png"
                        width="80px"
                      />
                    </figure>
                    <span>
                      <h5
                        className="smalltext invert uppercase"
                        style={{ paddingTop: 0 }}
                      >
                        App Cloning
                      </h5>
                    </span>
                  </div>
                  <div className="col4 center bg">
                    <figure>
                      <img
                        alt="Video Media"
                        src="/assets/features-9.png"
                        width="80px"
                      />
                    </figure>
                    <span>
                      <h5
                        className="smalltext invert uppercase"
                        style={{ paddingTop: 0 }}
                      >
                        UX &amp; UI personalization
                      </h5>
                    </span>
                  </div>
                </div>
              </section>
            </div>
            <div className="bg">
              <section className="frame" style={{ paddingTop: 0 }}>
                <div className="module12 std frame">
                  <div className="col12 center bg">
                    <button className="buttonlink">
                      <span className="buttontext invert">Learn More</span>
                      <span className="buttonicon">
                        <img src="/assets/icon-3.png" width="100%" />
                      </span>
                    </button>
                  </div>
                </div>
              </section>
            </div>
            <section id="community" className="frame">
              <div className="module12 std">
                <div className="col3 mcenter">
                  <h2>
                    Join Our
                    <br />
                    Newsletter
                  </h2>
                </div>
                <div className="col3 bottomalign P6">
                  <span className="smalltext uppercase">
                    {' '}
                    Email (Required)
                  </span>
                  <input style={{ width: '100%' }} type="text" />
                </div>
                <div className="col3 bottomalign P6">
                  <span>
                    <span className="smalltext uppercase"> Name</span>
                    <input style={{ width: '100%' }} type="text" />
                  </span>
                </div>
                <div className="col3 bottomalign P6">
                  <button className="buttonsub">
                    <span className="buttontext">Get Updates</span>
                  </button>
                </div>
              </div>
            </section>
            <section style={{ padding: 0 }} className="frame">
              <div className="module4 std">
                <span style={{ margin: '10rem 0' }} className="col4 line" />
                <div className="col1 mcenter">
                  <h3 className="subheader">Open Source</h3>
                  <p style={{ paddingTop: '0rem' }}>
                    Take part in making Fission better. Review our code, file
                    issues and send pull requests to help the ongoing
                    development.
                  </p>
                  <button style={{ paddingTop: 0 }} className="buttonlink">
                    <span className="buttontext">Github</span>
                    <span className="buttonicon">
                      <img src="/assets/icon-2.png" width="100%" />
                    </span>
                  </button>
                </div>
                <div className="col1 mcenter">
                  <h3 className="subheader">Community</h3>
                  <p style={{ paddingTop: '0rem' }}>
                    Attend demo days, test new features, ask questions and show
                    your Fission projects to our engaged community.
                  </p>
                  <button className="buttonlink">
                    <span className="buttontext">Forum</span>
                    <span className="buttonicon">
                      <img src="/assets/icon-2.png" width="100%" />
                    </span>
                  </button>
                </div>
                <div className="col1 mcenter">
                  <h3 className="subheader">Insights</h3>
                  <p style={{ paddingTop: '0rem' }}>
                    Find out what we’re up to and where we’re going as we share
                    our progress, ideas and vision.
                  </p>
                  <button className="buttonlink">
                    <span className="buttontext">
                      <a href="/blog/">Blog</a>
                    </span>
                    <span className="buttonicon">
                      <img src="/assets/icon-2.png" width="100%" />
                    </span>
                  </button>
                </div>
                <div className="col1 mcenter">
                  <h3 className="subheader">Support</h3>
                  <p style={{ paddingTop: '0rem' }}>
                    Chat with other Fission creators, help troubleshoot bugs
                    and brainstorm your ideas in real time.
                  </p>
                  <button className="buttonlink">
                    <span className="buttontext">Discord</span>
                    <span className="buttonicon">
                      <img src="/assets/icon-2.png" width="100%" />
                    </span>
                  </button>
                </div>
                <span style={{ margin: '10rem 0' }} className="col4 line" />
              </div>
            </section>
            <section style={{ padding: 0 }} className="frame">
              <div className="module12 std">
                <div className="col9 P4">Fission Internet Software</div>
                <ul className="col3 flex centeralign">
                  <li>
                    <a href="#process">Follow Newsletter</a>
                  </li>
                  <li>
                    <a href="#features">Twitter</a>
                  </li>
                  <li>
                    <a href>LinkedIn</a>
                  </li>
                </ul>
              </div>
            </section>
          </main>
        </div>
      </HomeLayout>
    </>
  )
}

export default Home
