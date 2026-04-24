#import "sbpo.typ": template
#import "@preview/algo:0.3.6": algo, i, d, comment, code
#show figure.where(
  kind: table
): t => { 
  set figure.caption(position: top)
  t
}

#show figure.caption.where(kind: table): it => {
  set text(size: 11pt)
  it
}
#show: template.with(
  title: "TíTULO DO ARTIGO",
  authors: (
    (
      name: "Primeiro Autor",
      institute: "Filiação",
      address: "Endereço da Instituição",
      email: "e-mail",
    ),
    (
      name: "Segundo Autor",
      institute: "Filiação",
      address: "Endereço da Instituição",
      email: "e-mail",
    ),
  ),
  resumo: [
    Este modelo resume as normas de formatação para os trabalhos completos a serem
    publicados nos Anais do LII SBPO. Título, filiação, resumo e palavras-chave
    devem repetir fielmente o que foi informado quando o autor cadastrou o artigo
    através do sistema de submissão. O Resumo deve ter no máximo 150 palavras.
  ],
  palchaves: [Problema do Caixeiro Viajante, Metaheurísticas, Algoritmo Genético, Algoritmo Memético, Algoritmo Transgenético. ],
  topicos-pt: [Tópicos: MH – Metaheurísticas , L&T – Logística e Transportes],
  abstract-en: [
    This document presents the format for full papers to be published in the Annals
    of the LII SBPO. Title, affiliation, abstract and keywords must be exactly the
    same as the author informed when registered the paper through the submission
    system. The Abstract must not exceed 150 words.
  ],
  keywords-en: [Traveling Salesman Problem, Metaheuristics, Genetic Algorithm, Memetic Algorithm, Transgenetic Algorithm.],
  topicos-en: [Topics: MH – Metaheuristics , L&T – Logistic and Transport.],
)

= Introdução

Com o avanço produtivo das sociedades ao decorrer das décadas, cada vez mais dados foram sendo coletados, aumentando a demanda pelo processamento em informações. Neste contexto, uma categoria de problemas que constantemente aparece pertencem à área da Otimização Combinatória. Tais problemas têm, para cada situação e conjunto de variáveis, um conjunto possível de soluções, onde o objetivo é encontrar a solução ótima para este cenário. Nesta categoria está o Problema do Caixeiro Viajante (PCV), uma classe de problemas que consiste em, dado um conjunto de cidades e uma matriz de distâncias entre elas, encontrar a rota com menor custo que atravesse todas as cidades uma única vez e retorne à cidade inicial #cite(<cervieri2000pcv>). 

Dentre as especializações do PCV está o Problema do Roteamento de Veículos (PRV), onde o objetivo é determinar a melhor rota a ser traçada pelo motorista de um veículo qualquer. O critério de melhor rota é definido pelo próprio problema, podendo ser desde menor tempo a menor custo e outros. Entretanto, o PCV pertence à classe de problemas NP-difícil, não tendo solução em tempo polinomial: conforme variam a quantidade de variáveis (cidades, capacidade do veículo, custo de energia e outras restrições), a abordagem de procurar pela melhor solução de forma exaustiva mostra-se pouco eficiente.

Como alternativas à abordagem exaustiva, foram desenvolvidas diversas heurísticas e meta-heurísticas capazes de resolver esta classe de problemas. Este trabalho tem como objetivo estudar e avaliar a aplicação dos algoritmos Genético, Memético e Transgenético, estratégias já consolidadas na literatura, a uma instância do problema do PRV, analisando as soluções encontradas em cada cenário do problema e seus desempenhos, bem como comparando com literaturas anteriores. O uso da linguagem de programação Rust também será abordado, explicando as vantagens de uso neste problema e detalhes de implementação que potencializam a eficiência dos algoritmos citados.

O cenário analisado no trabalho consiste na distribuição de laticínios por parte da Associação dos Pequenos Agropecuaristas do Sertão de Angicos (APASA): deve ser encontrada uma rota com origem em Angicos onde o veículo passe somente uma vez por cada cidade, buscando minimizar a distância da rota ou o tempo gasto. Com este estudo, será possível perceber tanto a utilidade de meta-heurísticas na resolução de problemas computacionalmente difíceis quanto o uso da linguagem Rust como alternativa mais eficiente a implementações tradicionais.   

Assim, o presente artigo está dividido da seguinte forma: na seção 2 estão as definições e explicações teóricas necessárias para o entendimento do trabalho; na seção 3 são apresentadas as estratégias

= Fundamentação Teórica

== Problema do Caixeiro Viajante (PCV)
O Problema do Caixeiro Viajante (PCV) é um dos problemas mais clássicos da literatura. Este problema consiste em permitir que
um viajante faça a rota de menor custo por $n$ cidades e retorne à cidade inicial, visitando
cada cidade uma única vez. É um resultado bem conhecido que o PCV é um problema NP-difícil, implicação direta da complexidade do problema do Ciclo Hamiltoniano #cite(<karp1975pcv>), tornando o uso de algoritmos exatos uma estratégia ineficiente e de alto custo computacional para encontrar soluções para instâncias do problema. 

Como alternativas surgiram as meta-heurísticas, algoritmos que proporcionam alta eficiência ao custo de não garantirem a solução ótima em todos os cenários. Além do menor tempo de processamento, outra vantagem das meta-heurísticas é a flexibilidade, característica possível com o uso de hiperparâmetros, configurações que controlam como o algoritmo explora o espaço de busca. 

Dentre a miríade de métodos heurísticos utilizados, alguns dos mais comuns incluem: Colônia de Formigas #cite(<stutzle2004ant>), Enxame de Partículas #cite(<eberhart1995particles>) e Algoritmos Genéticos #cite(<holland1975ga>) e Meméticos #cite(<moscato1989ma>). 

== Algoritmo Genético
O Algoritmo Genético consiste em uma sequência de etapas que busca simular o processo de adaptação evolutiva das soluções a cada iteração de modo a aumentar as chances de encontrar a solução ótima #cite(<holland1975ga>). 

Neste sistema, uma população de indivíduos (denominados "cromossomos") é gerada de forma aleatória. Após isso, os indivíduos são avaliados de acordo com seu _fitness_, o custo total. Em seguida, ocorrem os surgimentos de novas gerações: a cada iteração certos indivíduos são selecionados para cruzarem e gerar descendentes; adicionalmente, estes e outros cromossomos podem ter mutações introduzidas, de modo a diversificar ainda mais as populações e evitar estagnação em soluções subótimas. Com os novos indivíduos a população inicial é renovada e cromossomos de maior _fitness_ são eliminados. Então, o algoritmo encerra se a condição de parada for atingida ou continua a produzir novas gerações até alcançar esta condição.

== Algoritmo Memético
O Algoritmo Memético consiste em uma versão do Genético com a adição de uma Busca Local #cite(<moscato1989ma>). Buscas Locais são heurísticas de melhoramento local que, dada uma solução candidata, produz um conjunto de soluções vizinhas com custo potencialmente menor. Existem diversos exemplos destas buscas, tais como _Swap_, _Shift_, _Or-Opt_ e _2-Opt_.

Ao combinar o uso tradicional do Algoritmo Genético com Buscas Locais esta meta-heurística amplia a noção de evolução, validando tanto a evolução como espécie quanto a evolução pessoal de um único indivíduo. Assim, o Algoritmo Memético faz a exploração global e local dos cromossomos, podendo acelerar a descoberta da solução ótima.

== Algoritmo Transgenético
Algoritmos transgenéticos se baseiam na metáfora da teoria endossimbiótica e nas propriedades de fluxo celular #cite(<goldbargs2002>). Esta teoria propõe que a reprodução não necessariamente é um produto de uma relação binária, mas sim de uma relação entre dois ou mais seres. Diferentemente do genético, a transferência de genes ocorre de maneira horizontal, e não vertical, pois não há descendência entre gerações.

A reprodução acontece através de vetores transgenéticos, sendo eles: plasmídeos, vírus, plasmídeos recombinados ou transpósons #cite(<goldbargs2007>). Estes servem para transportar os genes para dentro de um hospedeiro seguindo a sequência de : Ataque, Transcrição, Bloqueio/Desbloqueio, Identificação e Recombinação.

= Metodologia
Nesta seção será detalhado o Problema do Roteamento de Veículos (PRV) aplicado à Associação dos Pequenos Agropecuaristas do Sertão de Angicos (APASA), os algoritmos utilizados e detalhes de implementação com a linguagem de programação Rust.

== Estudo de Caso: Distribuição de Produtos da APASA

Uma das operações presentes na APASA consiste na distribuição de laticínios através de um caminhão refrigerando, cujo trajeto tem como origem a cidade de Angicos e destinos como um conjunto de demais cidades do estado do Rio Grande do Norte. Neste problema existem 2 possíveis critérios para determinar a rota do veículo
1) menor tempo e 2) menor distância total. Para a APASA, determinar a rota com menor tempo significa a minimizar também o custo com a refrigeração do veículo, enquanto calcular a rota com menor distância acaba por minimizar o uso de combustível.

Este é um cenário já bem presente na literatura conforme visto em estudos anteriores: estabelecido em #cite(<silva2012vrp>), foi resolvido utilizando o _solver_ GLPK para instâncias de 6 a 24 cidades; em #cite(<fernandes2016ag>), o número de cidades é ampliado para 48 e a quantidade total de instâncias para 12: 6 para calcular menor tempo e 6 para menor distância. Adicionalmente, o problema foi resolvido com o uso de algoritmos genéticos e meméticos; em #cite(<menezes2025>), a abordagem descrita consiste no uso de três variações do algoritmo GRASP. 

Para o cenário do presente estudo, serão utilizadas exatamente as mesmas instâncias definidas em #cite(<fernandes2016ag>). Para maiores detalhes acerca das cidades recomenda-se a consulta do artigo original.

#figure(
  kind: table,
  caption: [Instâncias do PCV da APASA]
)[
#table(
  columns: (auto, auto, auto, 1fr),
  align: center,
  stroke: 0.5pt,
  table.header([*Instância*], [*Medida*], [*$n$*], [*Cidades pertencentes à instância (Nº - Quadro 1)*]
  ),
  underline[Problema 01], [Km], table.cell(rowspan: 2)[48],
  table.cell(rowspan:2)[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
  20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
  40, 41, 42, 43, 44, 45, 46, 47 e 48],
  underline[Problema 02], [Min],
  underline[Problema 03], [Km], table.cell(rowspan:2)[36],
  table.cell(rowspan:2)[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
  20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 e 36],
  [Problema 04], [Min],
  underline[Problema 05], [Km], table.cell(rowspan:2)[24],
  table.cell(rowspan:2)[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
  20, 21, 22, 23 e 24],
  [Problema 06], [Min],
  underline[Problema 07], [Km], table.cell(rowspan: 2)[12],
  table.cell(rowspan:2)[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 e 12],
  underline[Problema 08], [Min],
  underline[Problema 09], [Km], table.cell(rowspan:2)[7],
  table.cell(rowspan:2)[1, 7, 8, 9, 10, 11 e 12],
  underline[Problema 10], [Min],
  underline[Problema 11], [Km], table.cell(rowspan:2)[6],
  table.cell(rowspan:2)[1, 2, 3, 4, 5 e 6],
  underline[Problema 12], [Min],
)
#align(center)[
  #text(size: 10pt)[Fonte: #cite(<fernandes2016ag>)]
]  
] <tab:instancias>\

== Algoritmos utilizados

A fim de resolver o problema descrito, foram realizadas implementações para as meta-heurísticas dos Algoritmos Genético, Memético e Transgenético.
Cada uma das implementações foi realizada na linguagem Rust versão 1.85.0, a partir da representação dos problemas como um grafo direcionado, armazenado na estrutura de matriz de adjacência. 

Para a calibração dos hiper-parâmetros dos algoritmos foi utilizada a ferramenta _iRace_ #cite(<lopez2016irace>). A @tab:hiperparametros:gm apresenta os hiper-parâmetros utilizados para os algoritmos genético e memético, enquanto a @tab:hiperparametros:trans apresenta os do algoritmo transgenético.
#figure(
  kind: table,
  caption: [Hiper-parâmetros do AG/AM]
)[
#table(
  columns: (1fr, auto, auto, auto),
  align: center,
  stroke: 0.5pt,
  table.header([*Tipo do Problema*], [*Nº iterações*], [*Tamanho da população*], [*Taxa de mutação*]),
  [Tempo(min)], [2452], [197], [0.0193],
  [Distância(km)], [677], [195], [0.0152]
)\
#align(center)[
  #text(size: 10pt)[Fonte: Autoria própria (2026)]  
]
] <tab:hiperparametros:gm>

#figure(
  kind: table,
  caption: [Hiper-parâmetros do AG/AM]
)[
#table(
  columns: (1fr, auto, auto, auto),
  align: center,
  stroke: 0.5pt
)\
#align(center)[
  #text(size: 10pt)[Fonte: Autoria própria (2026)]  
]
] <tab:hiperparametros:trans>

=== Implementação do Algoritmo Genético

O algoritmo abaixo ilustra o funcionamento e execução do algoritmo genético:
#algo(
  title: emph(smallcaps("Algoritmo_Genético")),
  parameters: ([#math.italic("n")],),
  comment-prefix: [#sym.triangle.stroked.r ],
  comment-styles: (fill: rgb(100%, 0%, 0%)),
  indent-size: 15pt,
  indent-guides: 1pt + gray,
  row-gutter: 5pt,
  column-gutter: 5pt,
  inset: 5pt,
  stroke: 2pt + black,
  fill: none,
  main-text-styles: (font: "New Computer Modern")
)[
  Define hiper-parâmetros \
  G ← Carregar dados iniciais \
  P ← Gerar população inicial a partir de G \
  while não atinge condição de parada do #i \
    Faz o cruzamento entre os indivíduos da população de P\
    Escolhe indivíduos para mutação \
    Atualiza P \
]\


Na linha 2 ocorre o carregamento da instância. A inicialização deste grafo é feita de forma altamente eficiente através do uso de _procedural macros_, recurso do Rust que, neste cenário, carrega os dados da instância em tempo de compilação. Como o compilador conhece o grafo do problema ele é capaz de realizar otimizações mais agressivas, além de que nenhuma alocação foi feita na _heap_, somente na _stack_, tornando esta estratégia de inicialização dos dados importante para a velocidade do algoritmo. \

Na linha 3 ocorre a geração da população. A estratégia utilizada na solução foi inicializar um intervalo de 0 a $n$, onde $n$ é o número de nós (cidades) do problema e associar cada indivíduo a um número do intervalo de forma aleatória. \

Na linha 4 ocorre o loop principal do algoritmo. O número máximo de iterações é definido pelos hiper-parâmetros de cada execução. \

Na linha 5 ocorre o cruzamento dos indivíduos. A estratégia utilizada consistiu em dividir a população em 2 metades, realizar o crossover de cada elemento das duas metades e re-embaralhar o conjunto para permitir que diferentes indivíduos tenham a oportunidade de sofrer crossover. 

O Sequential Constructive Crossover (SCX) #cite(<ahmed2010ga>) foi utilizado para o crossover pois é considerado na literatura um dos melhores operadores #cite(<khan2015crossover>). A vantagem deste operador é manter características positivas dos pais enquanto descobre bons genes. 

A ideia deste crossover consiste em substituir um dos pais por um dos seus nós legítimos caso isso favoreça o _fitness_;
um nó legítimo é o primeiro nó visitado e que compõe a menor distância relativa ao nó atual, neste caso, o nó do pai analisado na iteração. É importante notar que o crossover não tem garantia de ser bem sucedido no algoritmo: caso um nó filho não tenha um fitness melhor que pelo menos um dos pais, ele não será aceito e a prole não será gerada.

Na linha 6 ocorre a mutação. A decisão tomada foi de que a mutação deve ocorrer somente em casos de crossover bem sucedidos. A ideia desta mutação é simples, consistindo em introduzir no indivíduo resultado da prole uma troca randômica entre 2 de seus nós sem se preocupar com o _fitness_ após isso.

Por fim, na linha 7 ocorre a renovação da população. Na implementação deste artigo, a renovação não ocorre de forma separada das outras etapas mas dentro do próprio cruzamento: ao substituir um dos indivíduos pais, o novo indivíduo garantidamente terá um menor _fitness_ que o anterior. Assim, cada geração terá um _fitness_ menor ou igual à anterior.

Adicionalmente, ao fim do processamento da geração é feita uma re-ordenação randômica dentro da população a fim de aumentar as chances de diversificação da prole na próxima geração. 

=== Implementação do Algoritmo Memético

Quanto ao algoritmo memético, a principal distinção para o genético é a existência da busca local após a fase da mutação. O algoritmo abaixo ilustra o funcionamento dele:

#algo(
  title: emph(smallcaps("Algoritmo_Memético")),
  parameters: ([#math.italic("n")],),
  comment-prefix: [#sym.triangle.stroked.r ],
  comment-styles: (fill: rgb(100%, 0%, 0%)),
  indent-size: 15pt,
  indent-guides: 1pt + gray,
  row-gutter: 5pt,
  column-gutter: 5pt,
  inset: 5pt,
  stroke: 2pt + black,
  fill: none,
  main-text-styles: (font: "New Computer Modern")
)[
  Define hiper-parâmetros \
  G ← Carregar dados iniciais \
  P ← Gerar população inicial a partir de G \
  while não atinge condição de parada do #i \
    Faz o cruzamento entre os indivíduos da população de P\
    Escolhe indivíduos para mutação \
    Faz a busca local nos indivíduos pós-mutação \
    Atualiza P \
]\

Com a adição da etapa da busca local, a estratégia adotada consistiu em sortear um número no intervalo $[1, 100)$ e com base neste aplicar determinadas buscas locais no indivíduo. A divisão do intervalo consistiu em:
- Entre 1 a 24: aplica a busca local Shift;
- Entre 25 a 49: aplica a busca local Swap;
- Entre 50 a 74: aplica a busca local Two Opt;
- Entre 75 a 99: aplica a busca local Or Opt.
\

A relação entre as buscas locais e os intervalos em que acontecem foi pensada de forma aleatória e sem levar critérios determinísticos em consideração, pois o objetivo é gerar o máximo de soluções diversas dentro do possível. 

=== Implementação do Algoritmo Transgenético

#algo(
  title: emph(smallcaps("Algoritmo_Transgenético")),
  parameters: ([#math.italic("n")],),
  comment-prefix: [#sym.triangle.stroked.r ],
  comment-styles: (fill: rgb(100%, 0%, 0%)),
  indent-size: 15pt,
  indent-guides: 1pt + gray,
  row-gutter: 5pt,
  column-gutter: 5pt,
  inset: 5pt,
  stroke: 2pt + black,
  fill: none,
  main-text-styles: (font: "New Computer Modern")
)[
  P ← Gerar população inicial \
  R ← Carregar as regras transgenéticas \
  H ← Carregar o banco de dados dos hospedeiros \
  while não atinge o critério de parada do #i \
    V ← Gera os vetores extra-intracelulares \
    C ← Seleciona os cromossomos para manipulação \
    Manipula C de acordo com R \
    Atualiza R e H \
]\

=== Ambientes computacionais

Os algoritmos descritos na seção 3 foram executados em computadores diferentes. Para o algoritmo genético, todas as instâncias foram executadas em um computador [Inserir marca] com processador Ryzen 9 5900X, [Inserir RAM e SSD], dentro do sistema operacional Arch Linux. Para o algoritmo memético, todas as instâncias foram executadas em um notebook Dell com processador Intel Core i7 Ultra 155H, [Ver com Paz]. Para o algoritmo transgenético,

= Resultados
// Nosso algoritmo goated vs impl original 
// Tabela dos nossos 3 algoritmos, com mínimo, média e desvio padrão p cada um
// Tabela dos nossos 3 algoritmos comparando com literatura 2025
// Por que o nosso foi mais eficiente
Nesta seção serão apresentados os resultados das execuções de cada algoritmo, com análise individual das implementações e comparativa com resultados anteriores da literatura acerca deste mesmo problema.

== Resultados individuais

#figure(
  kind: table,
  caption: [Resultados dos algoritmos]
)[
#table(
  columns: (1.8fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  align: center,
  stroke: 0.5pt,
  table.cell(rowspan: 2)[*Instância*],
  table.cell(colspan: 3)[*Genético*],
  table.cell(colspan: 3)[*Memético*],
  table.cell(colspan: 3)[*Transgenético*],
  [*Melhor*], [*Média*], [*Desvio (%)*],
  [*Melhor*], [*Média*], [*Desvio (%)*],
  [*Melhor*], [*Média*], [*Desvio (%)*],
  // dados
  [Instância 1], [1952.10], [2042.73], [25.97], [1942.30], [1960.57], [21.64], [], [], [],
  [Instância 2], [1996.00], [2025.01], [17.17], [1973.00], [1994.96], [12.19], [], [], [],
  [Instância 3], [1708.00], [1777.23], [21.29], [1695.00], [1701.51], [10.25], [], [], [],
  [Instância 4], [1663.00], [1697.99], [13.58], [1662.00], [1669.38], [7.37], [], [], [],
  [Instância 5], [1321.00], [1346.34], [10.26], [1321.00], [1324.63], [6.48], [], [], [],
  [Instância 6], [1223.00], [1240.54], [10.32], [1223.00], [1225.33], [4.72], [], [], [],
  [Instância 7], [672.70], [673.08], [2.29], [672.70], [672.72], [0.57], [], [], [],
  [Instância 8], [606.00], [606.18], [0.75], [606.00], [606.01], [0.16], [], [], [],
  [Instância 9], [438.30], [438.30], [0.15], [438.30], [438.30], [0.07], [], [], [],
  [Instância 10], [364.00], [364.00], [0.08], [364.00], [364.00], [0.00], [], [], [],
  [Instância 11], [344.90], [344.90], [0.00], [344.90], [344.90], [0.00], [], [], [],
  [Instância 12], [305.00], [305.00], [0.00], [305.00], [305.00], [0.00], [], [], [],
)
#align(center)[
  #text(size: 10pt)[Fonte: Autoria própria (2026)]
]
] <tab:resultados_individuais>

// TODO: quando trans tiver pronto adicionar uma análise aqui


== Comparação com literatura
A @tab:resultados_literatura apresenta uma comparação entre os resultados mínimos obtidos nos algoritmos deste trabalho com os de abordagens anteriores: utilizando as soluções do _GLPK_ e do algoritmo memético obtidos no trabalho de #cite(<fernandes2016ag>), e dos algoritmos _GRASP1_ e _GRASP2_ desenvolvidos por #cite(<menezes2025>). A seleção destes algoritmos levou em consideração a capacidade de encontrar melhores resultados, pois em #cite(<fernandes2016ag>) o memético (mais especificamente o _AM2_) se sobressaiu em relação ao genético, enquanto em #cite(<menezes2025>) o _GRASP3_ não conseguiu superar em nenhuma instância o _GRASP1_ ou _GRASP2_.

#figure(
  kind: table,
  caption: [Tabela comparativa entre soluções da literatura]
)[ 
#table(
  align: center,
  stroke: 0.5pt,
  columns: (1fr, auto, auto, auto, auto, auto, auto, auto),
  table.header([*Instância*], [*GLPK*], [*AM 2016*], [*GRASP1*], [*GRASP2*], [*AG 2026*], [*AM 2026*], [*AT 2026*]),
  [Instância 1], [*1942.30*], [2070.80], [2040.90], [2020.00], [1952.10], [*1942.30*], [], 
  [Instância 2], [*1973.00*], [2242.00], [2046.00], [2016.00], [1996.00], [*1973.00*], [], 
  [Instância 3], [1719.20], [1717.20], [1711.60], [1717.10], [1708.00], [*1695.00*], [], 
  [Instância 4], [1676.00], [1668.00], [1664.00], [1668.00], [1663.00], [*1662.00*], [], 
  [Instância 5], [1339.90], [*1321.00*], [*1321.00*], [*1321.00*], [*1321.00*], [*1321.00*], [], 
  [Instância 6], [*1223.00*], [*1223.00*], [1515.00], [*1223.00*], [*1223.00*], [*1223.00*], [], 
  [Instância 7], [*672.70*], [*672.70*], [*672.70*], [*672.70*], [*672.70*], [*672.70*], [], 
  [Instância 8], [*606.00*], [*606.00*], [609.00], [*672.70*], [*672.70*], [*672.70*], [], 
  [Instância 9], [*438.30*], [*438.30*], [*438.30*], [*438.30*], [*438.30*], [*438.30*], [], 
  [Instância 10], [*364.00*], [*364.00*], [*364.00*], [*364.00*], [*364.00*], [*364.00*], [], 
  [Instância 11], [*344.90*], [*344.90*], [*344.90*], [*344.90*], [*344.90*], [*344.90*], [], 
  [Instância 12], [*305.00*], [*305.00*], [*305.00*], [*305.00*], [*305.00*], [*305.00*], [], 
)
] <tab:resultados_literatura>

// TODO: adicionar análise quando tiver trans aqui tbm

= Conclusão 
// Sumarização do problema
// Sumarização da metodologia
// Sumarização dos resultados
// Próximos passos e possíveis melhorias

#bibliography("refs.bib", style: "sbpo.csl", title: "Referências")
