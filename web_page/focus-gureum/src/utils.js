export async function getToken(nickname, password, router) {
  try {
    const response = await fetch('/auth/generateToken', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ nickname, password })
    });

    if (!response.ok) {
      throw new Error(`Server error: ${response.statusText}`);
    }else{
        const data = await response.text();
        localStorage.removeItem('authToken');
        localStorage.setItem('authToken', data);
        router.push('/');
    }

  } catch (error) {
    console.error('Error during token fetch:', error);
  }
}
