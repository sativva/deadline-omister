// Run this example by adding <%= javascript_pack_tag 'hello_react' %> to the head of your layout file,
// like app/views/layouts/application.html.erb. All it does is render <div>Hello React</div> at the bottom
// of the page.

import React from 'react'
import ReactDOM from 'react-dom'
import Main from '../components/main'
import {AppProvider, Page, Card, Button} from '@shopify/polaris';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <AppProvider>
      <Page title="Example app">
        <Main />
        <Card sectioned>
          <Button onClick={() => alert('Button clicked!')}>Example button</Button>
        </Card>
      </Page>
    </AppProvider>,
    document.getElementById('app'),
  )
})
