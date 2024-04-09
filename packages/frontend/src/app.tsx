import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import './app.css';

export function App() {
  const router = createBrowserRouter([
    { path: "/", element: <p>root</p> },
    { path: "/login", element: <p>login</p> },
  ])
  return <><RouterProvider router={router} /></>;
}
