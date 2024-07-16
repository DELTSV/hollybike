/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

type FeatureItem = {
	title: string;
	Svg: React.ComponentType<React.ComponentProps<'svg'>>;
	description: JSX.Element;
};

const FeatureList: FeatureItem[] = [
	{
		title: 'Version Cloud',
		Svg: require('@site/static/cloud.svg').default,
		description: (
			<>
				Si vous ne souhaitez pas déployer vous même un serveur, nous pouvons vous fournir une version dans le cloud.
			</>
		),
	},
	{
		title: 'Version on-premise',
		Svg: require('@site/static/on-premise.svg').default,
		description: (
			<>
				Si vous souhaitez disposer de votre propre instance HollyBike, nous vous proposons une version à installer sur votre serveur. Nous fournissons également de l'aide à l'installation
			</>
		),
	},
	{
		title: 'Une application',
		Svg: require('@site/static/mobile.svg').default,
		description: (
			<>
				Peut importe la manière d'utiliser HollyBike, vous n'avez qu'une application mobile à utiliser pour plus de confort.
			</>
		),
	},
];

function Feature({title, Svg, description}: FeatureItem) {
	return (
		<div className={clsx('col col--4')}>
			<div className="text--center">
				<Svg className={styles.featureSvg} role="img"/>
			</div>
			<div className="text--center padding-horiz--md">
				<Heading as="h3">{title}</Heading>
				<p>{description}</p>
			</div>
		</div>
	);
}

export default function HomepageFeatures(): JSX.Element {
	return (
		<section className={styles.features}>
			<div className="container">
				<div className="row">
					{FeatureList.map((props, idx) => (
						<Feature key={idx} {...props} />
					))}
				</div>
			</div>
		</section>
	);
}
