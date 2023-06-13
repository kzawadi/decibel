import 'package:decibel/application/data_collection/data_collection_bloc.dart';
import 'package:decibel/presentation/core/app_defaults.dart';
import 'package:decibel/presentation/core/intererest_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InterestSelectScreen extends StatelessWidget {
  const InterestSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCollectionBloc, DataCollectionState>(
      builder: (context, state) {
        return Wrap(
          runAlignment: WrapAlignment.center,
          children: List.generate(
            InterestData.interestName.length,
            (index) {
              final currentIndex = InterestData.interestName[index];
              return _CustomChip(
                onTap: () {
                  context
                      .read<DataCollectionBloc>()
                      .add(DataCollectionEvent.selectInterest(currentIndex));
                  // _addItemToInterest(currentIndex);
                },
                active: state.selectedInterest.contains(currentIndex),
                label: currentIndex,
              );
            },
          ),
        );
      },
    );
  }
}

class _CustomChip extends StatelessWidget {
  const _CustomChip({
    required this.active,
    required this.label,
    required this.onTap,
  });

  final bool active;
  final String label;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppDefaults.defaulBorderRadius,
      child: AnimatedContainer(
        duration: AppDefaults.defaultDuration,
        decoration: BoxDecoration(
          color: active
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.secondary,
          borderRadius: AppDefaults.defaulBorderRadius,
          border: Border.all(
            color: active
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(4),
        child: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}
