import { mount } from 'svelte'
import './app.css'
import App from './App.svelte'
import { isEnvBrowser } from '$utils/misc'

if (isEnvBrowser()) {
  const root = document.getElementById('root');
  root!.style.height = '100vh';
  // root!.style.backgroundImage = 'url("background/night.png")';
  root!.style.backgroundImage = 'url("background/day.png")';
  root!.style.backgroundSize = 'cover';
  root!.style.backgroundRepeat = 'no-repeat';
  root!.style.backgroundPosition = 'center';
}

const app = mount(App, {
  target: document.getElementById('root')!,
})  

export default app
