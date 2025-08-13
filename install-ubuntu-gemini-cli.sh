#!/bin/bash

set -ex

echo "Checking for Node.js and npm..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed. Please install Node.js first using install-ubuntu-nodejs.sh"
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "npm is not installed. Please install npm first using install-ubuntu-nodejs.sh"
    exit 1
fi

echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

echo "Installing Gemini CLI..."
# Install the Google AI Node.js library and create a CLI wrapper
npm install -g @google/generative-ai

echo "Creating gemini CLI wrapper..."
# Create a simple CLI wrapper script
sudo tee /usr/local/bin/gemini > /dev/null << 'EOF'
#!/bin/bash
node -e "
const { GoogleGenerativeAI } = require('@google/generative-ai');
const genAI = new GoogleGenerativeAI(process.env.GOOGLE_API_KEY || '');
const model = genAI.getGenerativeModel({ model: 'gemini-pro' });

async function chat() {
  const prompt = process.argv.slice(2).join(' ');
  if (!prompt) {
    console.log('Usage: gemini <your question>');
    console.log('Set GOOGLE_API_KEY environment variable first');
    process.exit(1);
  }
  
  try {
    const result = await model.generateContent(prompt);
    const response = await result.response;
    console.log(response.text());
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

chat();
"
EOF

sudo chmod +x /usr/local/bin/gemini

echo "Verifying installation..."
gemini --help

echo "Gemini CLI installation complete!"
echo "You can now use 'gemini <your question>' to interact with Google's Gemini models."
echo "Don't forget to set your GOOGLE_API_KEY environment variable:"
echo "export GOOGLE_API_KEY='your-api-key-here'"
