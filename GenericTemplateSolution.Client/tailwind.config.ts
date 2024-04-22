import type { Config } from 'tailwindcss';

const config: Config = {
	content: ['./src/components/**/*.{ts,tsx}', './src/app/**/*.{ts,tsx}'],
	theme: {},
	plugins: [require('daisyui')],
};
export default config;
